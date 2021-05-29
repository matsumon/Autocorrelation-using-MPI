# Autocorrelation-using-MPI
Introduction

I like Wikipedia's definition of Autocorrelation:
"Autocorrelation, also known as serial correlation, is the correlation of a signal with a delayed copy of itself as a function of delay. Informally, it is the similarity between observations as a function of the time lag between them."

What does this actually mean? It means you take an apparently noisy signal, i.e., an array of length NUMELEMENTS random-looking values sampled over time:

You then multiply each array element by itself and add them up:


Sums[0] = A[0]*A[0] + A[1]*A[1] + ... + A[NUMELEMENTS-1]*A[NUMELEMENTS-1]

That will give you a large number because you are essentially taking the sum of the squares of the array elements. Big whoop. This is not interesting, so we ignore Sums[0]. The other Sums[*], however, are much more interesting.

You then shift the array over one index and do the pairwise multiplication again. This gives a resulting value of


Sums[1] = A[0]*A[1] + A[1]*A[2] + ... + A[NUMELEMENTS-1]*A[0]

Now, if the signal is truly noisy, there will be positive and negative array values in there being multiplied together, giving both positive and negative products. Many of these will cancel each other out. So, by doing this shift before multiplying, you will get a much smaller sum.

You then shift over by 2 indices and do it again,


Sums[2] = A[0]*A[2] + A[1]*A[3] + ... + A[NUMELEMENTS-2]*A[0] + A[NUMELEMENTS-1]*A[1]

and do it again, and do it again, and so on.

In the Sums[1] and Sums[2] lines of code above, notice the required wrap-around, back to A[0] and A[1]. Clearly, the logic to do this isn't hard, but it would help our flat-out parallelism if we didn't have to do that. More on this later.

What does this do? You then graph these resulting Sums[*] as a function of how much you shifted them over each time. If there is a secret sine wave hidden in the signal, well, let's just say that you will notice it in the graph of the Sums[*]. It's not even subtle. It will slap you in the face.

The presence of that harmonic will make the Sums[*] array be all positives for a while, then all negatives, then all positives, etc.

Scientists and engineers use the autocorrelation technique to see if there are regular patterns in a thought-to-be-random signal. For example, you might be checking for 60-cycle hum contamination in a sensor signal, or intelligent life elsewhere in the universe, etc.

The problem is that these signals can be quite large. Your job in this project is to implement this using MPI, and compare the performances across different numbers of processors.
Requirements:

    Read one of the signal files, either in text format which can be found here or in binary format which can be found here. You can look at the text version if you want. Each file has 8,388,608 (=8*1024*1024 =8M) signal ampliudes in it.

    To read the original signal data, see the code below.

    A not-paralleled C/C++ way of doing the multiplying and summing would be:


    for( int s = 0; s < MAXSHIFTS; s++ )
    {
    	float sum = 0.;
    	for( int i = 0; i < NUMELEMENTS; i++ )
    	{
    		sum += A[i] * A[i + s];
    	}
    	Sums[s] = sum;
    }

    Note that this works because A was dimensioned twice the size as the number of signal values, and then two copies of the signal were placed in it. This allows you to do the autocorrelation in one set of multiplies instead of wrapping around. So, your program will really be doing:


    Sums[0] = A[0]*A[0] + A[1]*A[1] + ... + A[NUMELEMENTS-2]*A[NUMELEMENTS-2] + A[NUMELEMENTS-1]*A[NUMELEMENTS-1]
    Sums[1] = A[0]*A[1] + A[1]*A[2] + ... + A[NUMELEMENTS-2]*A[NUMELEMENTS-1] + A[NUMELEMENTS-1]*A[NUMELEMENTS]
    Sums[2] = A[0]*A[2] + A[1]*A[3] + ... + A[NUMELEMENTS-2]*A[NUMELEMENTS]   + A[NUMELEMENTS-1]*A[NUMELEMENTS+1]
    . . .

    We won't do all NUMELEMENTS Sums[ ], we will just do MAXSHIFTS of them. That will be enough to uncover the secret sine wave.

    Do this using MPI parallelism.
    Each processor will be responsible for autocorrelating (NUMELEMENTS/NumCpus) elements.
    (However, it will need (NUMELEMENTS/NumCpus)+MAXSHIFTS elements to do it.)

    Scatterplot the autocorrelation Sums[*] vs. the shift. Even though there will be MAXSHIFTS Sums[*] values, only scatterplot Sums[1] ... Sums[255].

    There is a secret sine-wave in the signal. Scatterplotting Sums[1] ... Sums[255] will be enough to reveal it. Don't worry -- if you have done everything correctly, it will be really obvious.

    Don't include Sums[0] in the scatterplot. Sums[0] will be a very large number and will cause your auto-scaled vertical axis to have larger values on it than is good to view the secret sine-wave pattern.

    Tell me what you think the secret sine wave's period is, i.e., what change in shift gives you a complete sine wave?

    Draw a graph showing the performance versus the number of MPI processors you use. Pick appropriate units. Make "faster" go up.

    Turn into Teach:
        All your source code files (.c, .cpp).
        Your commentary in a PDF file. 

    Your commentary PDF should include:
        Show the Sums{1] ... Sums[255] vs. shift scatterplot.
        State what the secret sine-wave period is, i.e., what change in shift gets you one complete sine wave?
        Show your graph of Performance vs. Number of Processors used.
        What patterns are you seeing in the performance graph?
        Why do you think the performances work this way? 
