real Angle, Length, Length_mod, ang_mod;


element add_branches(real x0, real y0, real z0, real length, real angle)
{
	real x1, y1, z1;
	real rad;
	
	rad = angle * pi / 180;
	
	x1 = x0 + length * sin (rad);
	y1 = 0;
	z1 = z0 + length * cos (rad);
	
	if (length > 0.1) {
		length = length * Length_mod;
		add_branches(x1, y1, z1, length, angle + ang_mod);
		add_branches(x1, y1, z1, length, -angle + ang_mod);
	}
	return wire( x0, y0, z0, x1, y1, z1, #14, 7 );
}


void test_antenna(real min_f, real max_f, int steps)
{
	frequencySweep( min_f, max_f, steps );
}


model ( "dipole" ) 
{
	element driven ;
	
	driven = wire( 0.0, 0.0, 0.0, 0.0, 0.0, Length, #14, 19 ) ; 
	
	add_branches(0.0, 0.0, Length, 1.0, -Angle);
	add_branches(0.0, 0.0, Length, 1.0,  Angle);	
	
	voltageFeedAtSegment( driven, 1.0, 0.0, 1 );
	goodGround();
	
	setFrequency( 145.350 );
	
	frequencySweep( 144.0, 148.0, 10 );
	//frequencySweep( 144.0, 1480.0, 600 );
} 

control()
{
	real min, max, dx;

	printf("\n======\n");
	
	min = 1.97 ;
	max  = 1.98 ;
	dx = (max-min) / 10.0;
	
	Length_mod = 0.517100; 
	Angle = 58.2 ;
	
	Length = 1.977;
	
	ang_mod = 0;
	
	//while (Length <= max) {
		runModel();
		printf("%f, %f\n", Length, vswr( 1 ) );
		Length = Length + dx;
	//}
}
	
	
	
	