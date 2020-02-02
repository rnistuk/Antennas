// best:  L=0.982129, vswr = 1.428105

real Length;

model ( "dipole" ) 
{
	element driven ; 
	driven = wire( 0, 0, 0, 0, Length, 0, #11, 7 );
	voltageFeedAtSegment( driven, 1.0, 0.0, 0 );
	freespace();
	setFrequency( 145.350 );
	
	frequencySweep( 144.0, 148.0, 10 );
}


control()
{
	real length_at_min_swr, min_swr, prev_swr, curr_swr;
	real dL;
	
	min_swr = 99999.99;
	curr_swr = min_swr;
	
	Length = 0.982129;
	dL = 0.0001;
	
	printf("\t***\n");
	repeat(10)
	{
		prev_swr = curr_swr;
		runModel();
		
		curr_swr = vswr(1);
		printf("%f, %f, %f\n", Length, vswr(1), fabs(curr_swr - prev_swr));
		
		if (vswr(1) < min_swr) 
		{
			min_swr = vswr(1);
			length_at_min_swr = Length;
		}
		
		if (curr_swr>prev_swr) {
			dL = - 0.5 * dL; 
		}
		
		if (fabs(curr_swr - prev_swr) < 0.0001) 
		{
			printf("\n\tConverged\n");
			break;
		}
		
		Length = Length + dL;
	}
	printf("\n -> %f, %f\n", length_at_min_swr, min_swr);
}