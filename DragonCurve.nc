real g_angle, g_length;
element g_driven;
vector u;


void dragon_curve(int order, real length)
{
	right(order * 45.0);
	dragon_curve_recursive( order, length, 1);
}

void dragon_curve_recursive( int order,  real length, int sign)
{
	real root_half;
	if (order==0) 
	{
		g_driven = forward(length);
	}
	else
	{
		root_half = pow(0.5,0.5);
		dragon_curve_recursive(order - 1, length * root_half, 1);
		right(sign * -90);
		dragon_curve_recursive(order - 1, length * root_half, -1);
	}
}


model("dragon")
{
	g_angle = 0.0;
	u = vect(0.0,0.0,0.0);

	dragon_curve(6, g_length);
	voltageFeedAtSegment( g_driven, 1.0, 0.0, 1 );
	freespace();
	setFrequency( 145.350 );
}

control()
{
	real dl, curr_vswr, prev_vswr;

	g_length = 0.974000;
	dl=0.01;
	
	prev_vswr = 9999.9;
	
	curr_vswr = prev_vswr;
	
	printf("*****\n");
	repeat(30)
	{
		prev_vswr = curr_vswr;
		runModel();
		
		curr_vswr = vswr(1);
		
		if (curr_vswr > prev_vswr)
		{
			dl = -0.5 * dl; 
		}
		
		
		
		printf("%f, %f\n", g_length, curr_vswr);
		g_length = g_length + dl;
	}
}




void left(real da) 
{
	g_angle = g_angle - da;
}

void right(real da)
{
	g_angle = g_angle + da;
}

element forward(real l)
{
	element w;
	vector v;
	real r;
	
	r = g_angle * pi / 180.0;
	v = u + vect( 0, l * cos(r), l * sin(r));
	w = wire( u.x, u.y, u.z, v.x, v.y, v.z, #11, 13 );
	u = v;
	//wires[wire_count] = w;
	//++wire_count;

	return w;
}
