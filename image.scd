//Christopher Carney
//Music 452 Final Project

(
var q1, q2, q3, q4, q5;
var global_freq = 440;

//read the file
var path = thisProcess.nowExecutingPath.dirname +/+ "analysis_beach.csv";
x = CSVFileReader.read(path);

//create [R, G, B] arrays for different quadrants
q1 = [x[0][0], x[0][1], x[0][2]];
q2 = [x[0][3], x[0][4], x[0][5]];
q3 = [x[0][6], x[0][7], x[0][8]];
q4 = [x[0][9], x[0][10], x[0][11]];
q5 = [x[0][12], x[0][13], x[0][14]];

if ((q2[2] > q2[0]),
	{
		~q2_blue = 1;
	},
	{
		~q2_blue = 0;
	}
);

SynthDef.new("q2_whistle", {
	arg freq=440;
	var out;

	q=[Resonz.ar(PinkNoise.ar, LFNoise2.kr(2, freq/4, freq), 0.001),
		Resonz.ar(WhiteNoise.ar, LFNoise2.kr(2, freq/2, 2*freq), 0.001)
	];

	a=Select.ar(~q2_blue, q);
	o=Decay2.ar(a, 0.8, 6, 150, 0);

	/*if(q2[2] > q2[0],
		{
		a=Resonz.ar(PinkNoise.ar, LFNoise2.kr(2, freq/4, freq), 0.001);
		o=Decay2.ar(a, 0.8, 6, 150, 0);
		},
		{
		a=Resonz.ar(WhiteNoise.ar, LFNoise2.kr(2, freq/2, 2*freq), 0.001);
		o=Decay2.ar(a, 0.8, 6, 150, 0);
		}
	);*/

	b=RLPF.ar(Saw.ar(110), 440, 2);
	v=Decay2.ar(b, 0.8, 6, 0.05);

	out=((o) + (v));
	out=out*0.25;

	Out.ar(0, out);
	Out.ar(1, out);
}
).add;

x=Synth("q2_whistle", [\freq, global_freq]);
)

s.meter
File.getcwd;

