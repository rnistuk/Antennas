real Length;
real angle;
vector u;
int wire_count;
int driven_i;
int segment;
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
	w = wire( u.x, u.y, u.z, v.x, v.y, v.z, #11, 13 );
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

model ( "koch" ) 
{
	element driven ;
	real a;
	
	wire_count = 0;
	angle = 0.0;
	u = vect(0.0,0.0,0.0);	
	
	snowflake(Length, 3);
	
	driven = wires[driven_i];
	
	//wire( .1, 0, 0, .1, Length, 0, #11, 41 );
	
	voltageFeedAtSegment( driven, 1.0, 0.0, 1 );
	freespace();
	setFrequency( 145000.0 ); //145.350
	frequencySweep( 144000.0, 348000.0, 30 );
} 


control()
{
	//      L = 0.613875, swr = 1.741593
	// best L = 0.614000, swr = 1.741667
	//  L = 0.613687, swr = 1.594145
	real dL, curr_swr, prev_swr, min_l, min_swr;
	Length = 0.613562;
	dL = 0.0005;
	prev_swr = 9999.9;
	min_swr = 9999.9;
	driven_i = 22;
	
	printf("\n***** driven_i: %i\n", driven_i);	
	repeat(1)
	{
		runModel();
		curr_swr = vswr(1);
		printf("%f, %f\n", Length, curr_swr);
		
		if (curr_swr < min_swr) 
		{
			min_l = Length;
			min_swr = curr_swr;
		}
		
		if (curr_swr > prev_swr) 
		{
			dL = - 0.5 * dL;
		}
		
		
		if (fabs(curr_swr - prev_swr)<0.00001)
		{
			printf("\n Converged\n");
			break;
		}
		prev_swr = curr_swr;
		
		Length = Length + dL;
	}
	printf("\n\t L = %f, swr = %f\n", min_l, min_swr);
}
	
	
	
	