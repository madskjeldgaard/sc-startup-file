(
/**************************************** 
             Grain Envelopes 
*****************************************/    
    ~e.envs.clear; ~e.bufs.clear;

    ~e = ~e ? (); // Create Dict 
    ~e.envs = (); // Dict for envelopes
    ~e.bufs = (); // Dict for buffered envs


~grainenvs = {
    arg type, size;

    ~e.envs.clear; ~e.bufs.clear;

    ~e = ~e ? (); // Create Dict 
    ~e.envs = (); // Dict for envelopes
    ~e.bufs = (); // Dict for buffered envs

    // --- Curtis Roads Envelopes ---
    // Envelopes as described in 
    // Microsound by Curtis Roads, p. 89

    // Gaussian (a)
    ~e.envs.gaussian = Env([0, 1.0 ,0], [(1/2)*size, (1/2)*size], curve: 'sin'); // Make an envelope and send it to a buffer
    ~e.bufs.gaussian = Buffer.sendCollection(s, ~e.envs.gaussian.discretize, 1);

    // Quasi-Guassian (b) 
    ~e.envs.quasigaussian = Env([0, 1.0, 1.0 ,0], [(1/3)*size, (1/3)*size, (1/3)*size], curve: 'sin'); // Make an envelope and send it to a buffer
    ~e.bufs.quasigaussian= Buffer.sendCollection(s, ~e.envs.quasigaussian.discretize, 1);

    // Three-Stage Line Segment (c) 
    ~e.envs.threestage = Env([0, 1.0, 1.0 ,0], [(1/3)*size,  (1/3)*size, (1/3)*size]); // Make an envelope and send it to a buffer
    ~e.bufs.threestage = Buffer.sendCollection(s, ~e.envs.threestage.discretize, 1);

    // Triangular (d)
    ~e.envs.tri = Env([0,1,0], [(1/2)*size, (1/2)*size]); // Make an envelope and send it to a buffer
    ~e.bufs.tri = Buffer.sendCollection(s, ~e.envs.tri.discretize, 1);

    // Sinc function (e)
    ~e.envs.sinc = Env([0, 0.1, -0.1, 0.25, -0.25, 1.0, 1.0, -0.25, 0.25, -0.1, 0.1, 0], 
                       [(1/9)*size,(1/9)*size,(1/9)*size,(1/9)*size,
                       (1/9)*size,(1/9)*size,(1/9)*size,(1/9)*size,
                       (1/9)*size,(1/9)*size], curve: 'sine');  // Make an envelope and send it to a buffer

    ~e.bufs.sinc = Buffer.sendCollection(s, ~e.envs.sinc.discretize, 1);

    // Expodec (f)
    ~e.envs.expodec = Env([1, 0.0001], [(1/2) * size, (1/2) * size], curve:'exp'); // Make an envelope and send it to a buffer
    ~e.bufs.expodec = Buffer.sendCollection(s, ~e.envs.expodec.discretize, 1);

    // Rexpodec (g)
    ~e.envs.rexpodec = Env([0.0001, 1], [(1/2) * size, (1/2) * size], curve:'exp'); // Make an envelope and send it to a buffer
    ~e.bufs.rexpodec = Buffer.sendCollection(s, ~e.envs.rexpodec.discretize, 1);

    // --- Custom envelopes --- 
    // by Gilberte

    // "Blob" Function - custom envelope 

    ~e.envs.blob= Env([0, 0.25, 0.5, 0.75, 1.0, 1.0, 0.75, 0.5, 0.25 ,0], 
                       [(1/9)*size,(1/9)*size,(1/9)*size,(1/9)*size,
                       (1/9)*size,(1/9)*size,(1/9)*size,(1/9)*size,
                       (1/9)*size,(1/9)*size], curve: 'sin');  // Make an envelope and send it to a buffer
    ~e.bufs.blob= Buffer.sendCollection(s, ~e.envs.blob.discretize, 1);

    // Function to return envelope depending on input arg type
    ~envchoice = case
    { type == 'gauss' } {~e.bufs.gaussian }
    { type == 'quasi' } {~e.bufs.quasigaussian }
    { type == 'three' } {~e.bufs.threestage}
    { type == 'tri' } {~e.bufs.tri }
    { type == 'sinc' } {~e.bufs.sinc }
    { type == 'exp' } {~e.bufs.expodec }
    { type == 'rex' } {~e.bufs.rexpodec }
    { type == 'blob' } {~e.bufs.blob}
    { type == 'random' } {~e.bufs.choose}; // Random choice of envelope
    // Return choice of envelope
    ~envchoice;
};

)
(
~grainenvs.value.plot;


)
