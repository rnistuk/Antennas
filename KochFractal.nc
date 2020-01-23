real Length;
real angle;
vector u;
int wire_count;
int driven_i;
element wires[1024];

void left(real da) 
{
	angle = angle - da;
}

void right(real da)
{
	angle = angle + da;
}

element forward(real l)
{
	element w;
	vector v;
	real r;
	
	r = angle * pi / 180.0;
	v = u + vect( 0, l * cos(r), l * sin(r));
	w = wire( u.x, u.y, u.z, v.x, v.y, v.z, #11, 11 );
	u = v;
	wires[wire_count] = w;
	++wire_count;

	return w;
}

element snowflake(real ls, int n)
{
	if (n==0) {
		return forward(ls);
	}
	ls = ls / 3.0;
	snowflake(ls, n - 1);
	right(60);
	snowflake(ls, n - 1);
	left(120);
	snowflake(ls, n - 1);
	right(60);
	return snowflake(ls, n - 1);
}

model ( "dipole" ) 
{
	element driven ;
	real a;
	
	wire_count = 0;
	angle = 0.0;
	u = vect(0.0,0.0,0.0);	
	
	snowflake(Length, 3);
	
	driven = wires[driven_i];
	
	voltageFeedAtSegment( driven, 1.0, 0.0, 10 );
	freespace();
	setFrequency( 145.350 );
	frequencySweep( 144.0, 148.0, 10 );
} 



control()
{
	real dy, current, previous;
	
	dy = -0.001;
	Length = 2.157500;
	previous = 999.9;
	driven_i = 23;
	printf(" ********\n");
	repeat (5) {
		runModel();
		current = vswr(1);
		printf("%f, %f\n", Length, current);
		if (current > previous) {
			dy = -dy *0.5; 
		}
		previous = current;
		Length = Length + dy;
	}	
}
	
	
	
	