
float radius;

element ring(real x0, real y0, real z, real r)
{
	real angle, da;
	float xp, yp, xc, yc;
	int n;
	element driven;
	
	n=25;
	da = 2 * pi / n;
	angle = 0;
	
	xp = r * cos(angle);
	yp = r * sin(angle);
	repeat (n) {
		angle = angle + da;
		xc = r * cos(angle);
		yc = r * sin(angle);
		driven = wire( xp, yp, z, xc, yc, z, #11, 7 );
		xp = xc;
		yp = yc;		
	}
	return driven;
}

model ("magloop")
{
	element driven;
	driven = ring( 0, 0, 1.01, 0.1);
	ring( 0, 0, 1.0, radius);
	
	voltageFeedAtSegment( driven, 1.0, 0.0, 0 );
 	setFrequency( 145.350 );
}

control ()
{
	printf("\n\n\n");
	radius = 0.2;
	repeat(50)
	{
		radius = radius + 0.01;		
		runModel();
		printf(" %f, %f \n", radius, vswr(1));
	}
}
