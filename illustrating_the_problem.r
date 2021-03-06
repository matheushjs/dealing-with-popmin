require(viridis);
require(colorspace);
require(magick);

mycolors = c(
	"#000000",
	"#FF0000AA",
	"blue",
	"#FF00FFFF",
	"#FFFF00FF",
	"#999999FF"
);

mylwd = c(3, 5, 4);
mylty = c(1, 2, 3);

graphics.off();
scale=0.6;
dev.new(width=scale*14, height=scale*7);

realParams = c(4*20, 2/4);
myC = 28

mydist = function(x, shape, scale, c=myC){
	dgamma(x - c, shape=shape, scale=scale);
}

x = seq(0, 400, length=5000);

# Now we find the closest gamma near that function
difference = function(params, c=myC){
	slice = x[x > c];
	-sum(log(mydist(slice, shape=params[1], scale=params[2], c=c)) * dgamma(slice, shape=realParams[1], scale=realParams[2]));
}

params = optim(c(10, 2), difference, method="L-BFGS", lower=c(1e-3, 1e-3))$par;
print(params);
#params = c(21.684924, 0.975353); # What the above optimization finds

#data = rgamma(n=50, shape=realParams[1], scale=realParams[2]);
#print(data);
#data = c(45.42578,37.14454,31.91805,78.38157,51.13203,76.95387,34.06098,34.73172,26.69495,67.43486,98.01783,61.88397,41.99400,34.95689,51.49814,56.23078,55.54928,44.69236,36.25360,59.33179)
data = c(34.5872790234773, 38.4919122192951, 41.6603005379936, 31.5172329624416, 38.8287748705354, 37.8996622953713, 32.5246040914959, 45.3525837995592, 44.8026066314741, 45.2298340027216, 35.605516846119, 37.3695439015207, 33.4290231688788, 40.6211016549395, 37.5745370071785, 44.7818618485457, 44.9588657557767, 47.1303386264298, 45.6558881748033, 36.7305382714599, 41.8318347406842, 36.6986885624459, 39.9338917563526, 42.2560064269337, 43.7758972196999, 41.3428319566796, 37.3961626064094, 41.0842694042709, 37.8368915410187, 40.3478573205334, 38.5302660345251, 46.7667289597967, 37.6292152359453, 39.570547062534, 35.4443575872169, 41.0458729149094, 39.8236322839775, 52.3231618350361, 32.1630990637425, 43.1722403440007, 41.056450855115, 38.4423376592774, 44.6139227774248, 41.9031092985105, 51.0127183407746, 34.1196123463208, 40.3193924149698, 36.2400167765862, 41.2829580779968, 33.8549887866623);

# Histogram
hist(data, freq=FALSE, border=F, col="#A0A0A070", xlab="", ylab="", xlim=c(0, 100), ylim=c(0, 0.15), axes=FALSE, breaks=20);
axis(1, pos=0);
axis(2, pos=0);
title(xlab="x", ylab="density", line=1);

# Inferred dist
lines(x[x>myC], dgamma(x[x>myC], shape=realParams[1], scale=realParams[2]) / (1 - pgamma(myC, shape=realParams[1], scale=realParams[2])) * 1.05, type="l", lwd=mylwd[2], col=mycolors[2], lty=mylty[2]);
abline(v=myC, col=1, lwd=2, lty="12");

# Real dist
lines(x, dgamma(x, shape=realParams[1], scale=realParams[2]), lwd=mylwd[1], lty=mylty[1], col=mycolors[1]);

#legend("topright", c("real dist.", "inferred dist.", "trunc. real dist.", "experimental data"), col=c(mycolors[1:3], "#A0A0A070"), lty=c(mylty[1:3], 1), lwd=c(mylwd[1:3]/1.8, 15), box.lwd=0);
legend("topright", c("real dist.", "truncated dist.", "experimental data"), col=c(mycolors[1:2], "#A0A0A070"), lty=c(mylty[1:2], 1), lwd=c(mylwd[1:2]/1.8, 15), box.lwd=0);

text(18, 0.033, expression(group("[", list(c, infinity), ")")), pos=4);
arrows(19, 0.031, 35, 0.031, length=0.1);

savePlot("fig1.png");
#system("convert fig1.png -crop 624x316+40+72 fig1.png");

img = image_read("fig1.png");
img = image_convert(img, type="grayscale");
dev.new();
plot(img);

dev.new(width=scale*16, height=scale*7);

hist(data, freq=FALSE, border=F, col="#A0A0A070", xlim=c(13, 70), ylim=c(0, 0.12), axes=FALSE, xlab="", ylab="", breaks=20);
axis(1, pos=0);
axis(2, pos=13);
title(xlab="x", ylab="density", line=1);

lines(x[x>13], dgamma(x[x>13], shape=realParams[1], scale=realParams[2]), lwd=mylwd[1], lty=mylty[1], col=mycolors[1]);
lines(x[x>myC], mydist(x[x>myC], params[1], params[2]), type="l", lwd=mylwd[3], col=mycolors[3], lty=mylty[3]);
abline(v=myC, col=1, lwd=2, lty="12");

lines(x[x>myC], dgamma(x[x>myC], shape=realParams[1], scale=realParams[2]) / (1 - pgamma(myC, shape=realParams[1], scale=realParams[2])) * 1.05, type="l", lwd=mylwd[2], col=mycolors[2], lty=mylty[2]);

legend("topright", c("real distribution", "truncated distribution", "inferred distribution", "experimental data"), col=c(mycolors[1:3], "#A0A0A070"), lty=mylty[1:3], lwd=c(mylwd[1:3]/1.8, 15), box.lwd=0);
#text(18, 0.033, "shifted\norigin", pos=4);
#arrows(19, 0.031, 35, 0.031, length=0.1);

text(myC, 0.11, expression(group("[", list(c, infinity), ")")), pos=4);
arrows(myC, 0.1, 35, 0.1, length=0.1);

savePlot("fig2.png");
#system("convert fig2.png -crop 624x316+40+72 fig2.png");

img = image_read("fig2.png");
img = image_convert(img, type="grayscale");
dev.new();
plot(img);

stop();

dev.new(width=scale*14, height=scale*7);

data = data[1:10];
hist(data, freq=FALSE, border=F, col="#A0A0A070", xlim=c(0, 100), ylim=c(0, 0.055), axes=FALSE, xlab="", ylab="");
axis(1, pos=0);
axis(2, pos=0);
title(xlab="x", ylab="density", line=1);

lines(x, dgamma(x, shape=realParams[1], scale=realParams[2]), lwd=mylwd[1], lty=mylty[1], col=mycolors[1]);

n = length(data);
CV = sd(data) / mean(data);
est1 = min(data);
est2 = min(data) - abs(min(data)) * (CV / log10(n));
est3 = min(data) - abs(min(data)) * (CV / n);
est4 = min(data) - abs(min(data)) * CV * sqrt(log(log(n)) / (2*n));
est5 = min(data) - abs(min(data)) * CV * sqrt(-log(0.05/2) / (2*n));

y = 0.02
lwd = 4
cols = viridis(6)[1:5];
mycex = 2;
segments(est1, 0, y1=y, col=cols[1], lwd=lwd, lty="12");
points(est1, y, cex=mycex, col=cols[1], pch=19);
#text(est1, y+0.002, "est1");

y = y + 0.003
segments(est3, 0, y1=y, col=cols[2], lwd=lwd, lty="12");
points(est3, y, cex=mycex, col=cols[2], pch=19);
#text(est3, y+0.002, "est3");

y = y + 0.003
segments(est4, 0, y1=y, col=cols[3], lwd=lwd, lty="12");
points(est4, y, cex=mycex, col=cols[3], pch=19);
#text(est4, y+0.002, "est4");

y = y + 0.003
segments(est5, 0, y1=y, col=cols[4], lwd=lwd, lty="12");
points(est5, y, cex=mycex, col=cols[4], pch=19);
#text(est5, y+0.002, "est5");

y = y + 0.003
segments(est2, 0, y1=y, col=cols[5], lwd=lwd, lty="12");
points(est2, y, cex=mycex, col=cols[5], pch=19);
#text(est2, y+0.002, "est2");

legends=list(
	"sample\nmin",
	expression(over(CV, log[10](n))),
	expression(over(1,n)),
	expression(sqrt(over(log(log(n)), 2*n))),
	expression(sqrt(over(-log(nu/2), 2*n)))
);
legends = legends[c(1,3,4,5,2)];

myx = rev(c(0.5, 20, 45, 70, 80)) + 5;
for(i in 1:5){
	legend(myx[i], 0.045, yjust=0, legend=legends[[i]], pch=19, col=cols[i], box.lwd=0, pt.cex=2);
}

savePlot("fig3.png");
#system("convert fig3.png -crop 624x316+40+72 fig3.png");

img = image_read("fig3.png");
img = image_convert(img, type="grayscale");
dev.new();
plot(img);

dev.new(width=scale*14, height=scale*7);

plot(c(-1,-1), xlim=c(0, 100), ylim=c(0, 0.055), axes=FALSE, xlab="", ylab="");
axis(1, pos=0);
axis(2, pos=0);
title(xlab="x", ylab="density", line=1);

plotFuncDiff = function(x, y1, y2, ...){
	forwardPart  = cbind(x, y1);
	backwardPart = cbind(rev(x), rev(y2));
	all = rbind(forwardPart, backwardPart, c(x[1], y1[1]));
	polygon(all, ...);
}

#lines(x[x>myC], mydist(x[x>myC], params[1], params[2]), type="l", lwd=mylwd[2], col=mycolors[2], lty=mylty[2]);
#abline(v=myC, col=1, lwd=2, lty="12");

#lines(x[x > myC], dgamma(x[x > myC], shape=realParams[1], scale=realParams[2]) / pgamma(myC, shape=realParams[1], scale=realParams[2], lower.tail=FALSE), lwd=mylwd[1], lty=mylty[1], col=mycolors[1]);

f = function(c, raiseY=0, ...){
	difference = function(params){
		slice = x[x > c];
		-sum(log(mydist(slice, shape=params[1], scale=params[2], c=c)) * dgamma(slice, shape=realParams[1], scale=realParams[2]));
	}

	mockData = rgamma(n=2000, shape=realParams[1], scale=realParams[2]) - c;
	initShape = 2;
	initScale = mean(mockData[mockData > 0]) / initShape;

	params = optim(c(initShape, initScale), difference, method="L-BFGS", lower=c(1e-3, 1e-3))$par;
	print(params);

	# abline(v=c, lty="13", lwd=2);
	plotFuncDiff(
		x[x > c],
		mydist(x[x > c], params[1], params[2], c=c) + raiseY,
		dgamma(x[x > c], shape=realParams[1], scale=realParams[2]) / pgamma(c, shape=realParams[1], scale=realParams[2], lower.tail=FALSE) + raiseY,
		...
	);

	segments(c, 0, c, raiseY, lwd=3, lty="12", col="#00000077");

	# Estimate area under curve
	y1 = mydist(x[x > c], params[1], params[2], c=c);
	y2 = dgamma(x[x > c], shape=realParams[1], scale=realParams[2]) / pgamma(c, shape=realParams[1], scale=realParams[2], lower.tail=FALSE);
	diffs = abs(y1 - y2);
	diffs = diffs[2:length(diffs)];
	
	sum(diff(x[x > c]) * diffs);
}

allC = c(25, 20, 15, 10, 7.5, 5);
allCols = viridis(length(allC)+1, alpha=0.8)[1:length(allC)];
areas = seq_along(allC);
for(i in 1:length(allC)){
	areas[i] = f(allC[i], 0.004*(length(allC) - i), col=allCols[i]);
}

legend("topright", paste("c = ", allC, "	area = ", round(areas, digits=3)), col=allCols, pch=15, pt.cex=2.5, box.lwd=0);
#text(18, 0.033, "shifted\norigin", pos=4);
#arrows(19, 0.031, 35, 0.031, length=0.1);

savePlot("fig4.png");
#system("convert fig4.png -crop 624x316+40+72 fig4.png");

img = image_read("fig4.png");
img = image_convert(img, type="grayscale");
dev.new();
plot(img);


dev.new(width=scale*14, height=scale*7);

#hist(data, freq=FALSE, border=F, col="#A0A0A070", xlim=c(0, 100), ylim=c(0, 0.045), axes=FALSE, xlab="", ylab="");

x = seq(0, 45, length=2000);
plot(x, dweibull(x, shape=18, scale=35), lwd=mylwd[1], lty=mylty[1], col=mycolors[1], axes=FALSE, xlab="", ylab="", type="l", xlim=c(15, 40));
axis(1, pos=0);
axis(2, pos=15);
title(xlab="x", ylab="density", line=1);

q = 0.05
# I will just recycle the names here... sorry I'm lazy
est1 = qweibull(1 - (1 - q)**(1/10), shape=18, scale=35);
est2 = qweibull(1 - (1 - q)**(1/20), shape=18, scale=35);
est3 = qweibull(1 - (1 - q)**(1/50), shape=18, scale=35);
est4 = qweibull(1 - (1 - q)**(1/100), shape=18, scale=35);
est5 = qweibull(1 - (1 - q)**(1/200), shape=18, scale=35);

y = 0.05
lwd = 4
cols = viridis(6)[1:5];
mycex = 2;
segments(est1, 0, y1=y, col=cols[1], lwd=lwd, lty="12");
points(est1, y, cex=mycex, col=cols[1], pch=19);
#text(est1, y+0.02, "10");

y = y + 0.012
segments(est2, 0, y1=y, col=cols[2], lwd=lwd, lty="12");
points(est2, y, cex=mycex, col=cols[2], pch=19);
#text(est2, y+0.02, "20");

y = y + 0.012
segments(est3, 0, y1=y, col=cols[3], lwd=lwd, lty="12");
points(est3, y, cex=mycex, col=cols[3], pch=19);
#text(est3, y+0.02, "50");

y = y + 0.012
segments(est4, 0, y1=y, col=cols[4], lwd=lwd, lty="12");
points(est4, y, cex=mycex, col=cols[4], pch=19);
#text(est4, y+0.02, "100");

y = y + 0.012
segments(est5, 0, y1=y, col=cols[5], lwd=lwd, lty="12");
points(est5, y, cex=mycex, col=cols[5], pch=19);
text(est5-1, y+0.01, "5%");

q = 0.01
# I will just recycle the names here... sorry I'm lazy
est1 = qweibull(1 - (1 - q)**(1/10), shape=18, scale=35);
est2 = qweibull(1 - (1 - q)**(1/20), shape=18, scale=35);
est3 = qweibull(1 - (1 - q)**(1/50), shape=18, scale=35);
est4 = qweibull(1 - (1 - q)**(1/100), shape=18, scale=35);
est5 = qweibull(1 - (1 - q)**(1/200), shape=18, scale=35);

y = 0.02
lwd = 4
cols = viridis(6)[1:5];
mycex = 2;
segments(est1, 0, y1=y, col=cols[1], lwd=lwd, lty="12");
points(est1, y, cex=mycex, col=cols[1], pch=19);
#text(est1, y+0.02, "10");

y = y + 0.012
segments(est2, 0, y1=y, col=cols[2], lwd=lwd, lty="12");
points(est2, y, cex=mycex, col=cols[2], pch=19);
#text(est2, y+0.02, "20");

y = y + 0.012
segments(est3, 0, y1=y, col=cols[3], lwd=lwd, lty="12");
points(est3, y, cex=mycex, col=cols[3], pch=19);
#text(est3, y+0.02, "50");

y = y + 0.012
segments(est4, 0, y1=y, col=cols[4], lwd=lwd, lty="12");
points(est4, y, cex=mycex, col=cols[4], pch=19);
#text(est4, y+0.02, "100");

y = y + 0.012
segments(est5, 0, y1=y, col=cols[5], lwd=lwd, lty="12");
points(est5, y, cex=mycex, col=cols[5], pch=19);
text(est5-1, y+0.01, "1%");

legend(17, 0.15, c("200", "100", "50", "20", "10"), title="sample size", yjust=0, pch=19, col=rev(cols), box.lwd=0, pt.cex=2, horiz=TRUE);

savePlot("fig5.png");
#system("convert fig5.png -crop 624x316+40+72 fig5.png");

img = image_read("fig5.png");
img = image_convert(img, type="grayscale");
dev.new();
plot(img);

stop()
