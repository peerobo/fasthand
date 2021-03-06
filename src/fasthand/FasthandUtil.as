package fasthand 
{
	import base.LangUtil;
	import flash.utils.describeType;
	/**
	 * ...
	 * @author ndp
	 */
	public class FasthandUtil 
	{
		public static var letters:String = "a;b;c;d;e;f;g;h;i;j;k;l;m;n;o;p;q;r;s;t;u;v;w;x;y;z;";
        public static var food1:String = "apple;banana;bread;chocolate;egg;grapes;milk;orange;pear;rice;hamburger;cake;carrot;coffee;corn;fish;tomato;noodles;strawberry;broccoli;chili;cookie;onion;orange juice;peach;peas;sandwich;soup;steak;watermelon;";
        public static var food2:String = "cola;cucumber;hot dog;ice;lettuce;bell pepper;pineapple;pizza;potato;tea;beer;cheese;cherry;coconut;eggplant;hot chocolate;lemon;mushroom;spaghetti;pie;butter;celery;cereal;garlic;ginger;grapefruit;kiwi;milkshake;sausage;whiskey;";
        public static var animals1:String = "bird;cat;dog;elephant;fish;horse;mouse;pig;snake;tiger;lion;monkey;chicken;giraffe;frog;dragon;duck;sheep;cow;whale;rat;bear;panda;wolf;penguin;goat;shark;leopard;fox;butterfly;";
        public static var animals2:String = "ant;bee;bull;dolphin;camel;dinosaur;donkey;eagle;kangaroo;turtle;caterpillar;deer;fly;hippo;lizard;octopus;parrot;rhino;snail;worm;goldfish;gorilla;monster;ostrich;seal;skunk;slug;squirrel;swan;zebra;badger;beetle;buffalo;grasshopper;hedgehog;kitten;koala;lamb;peacock;puppy;";
        public static var kitchen:String = "bottle;bowl;cup;fork;glass;jar;jug;knife;plate;spoon;bath;faucet;hairbrush;mirror;shower;sink;soap;toothbrush;toothpaste;towel;chopping board;cleaver;cloth;frying pan;kettle;ladle;saucepan;spatula;teapot;tray;";
        public static var nature:String = "beach;bush;flower;island;lake;leaf;mountain;river;tree;wave;cloud;lightning;moon;rain;rainbow;snow;star;sun;tornado;wind;";
        public static var transport:String = "bike;bus;car;motorbike;plane;ship;taxi;train;truck;walking;ambulance;elevator;escalator;fire engine;glider;helicopter;rocket;skateboard;tractor;van;";
        public static var computer:String = "computer;mouse;keyboard;laptop;monitor;headset;printer;speakers;battery;light bulb;usb stick;dvd;dvd player;switch;line;microphone;plug;socket;webcam;";
        public static var numbers1:String = "zero;one;two;three;four;five;six;seven;eight;nine;ten;eleven;twelve;thirteen;fourteen;fifteen;sixteen;seventeen;eighteen;nineteen;twenty;";
        public static var numbers2:String = "twenty one;twenty two;twenty three;twenty four;twenty five;twenty six;twenty seven;twenty eight;twenty nine;thirty;one hundred;two hundred;one thousand;two thousand;ten thousand;twenty thousand;one hundred thousand;two hundred thousand;one million;one billion;";
        public static var adjectives:String = "big;small;tall;short;new;old;fast;slow;fat;thin;happy;sad;heavy;light;hot;cold;long;young;";
        public static var stationary:String = "eraser;notepad;paintbrush;paper;pen;pencil;pencil case;ruler;scissors;sharpener;board;calculator;cards;compass;crayons;fountain pen;marker;penknife;protractor;whistle;";
        public static var garden:String = "barbeque;bucket;fence;gate;ladder;lawnmower;shed;spade;swing;wall;bench;broom;chimney;coat rack;drain;dustpan and brush;flower bed;lawn;mop;wheel barrow;";
        public static var hospital:String = "black eye;broken arm;cold;cough;cut;headache;nose bleed;rash;sore throat;stomach ache;bandage;blood;crutches;injection;iv drip;medicine;needle;pill;plaster;wheel chair;";
        public static var personal:String = "bag;camera;card;glasses;key;mobile phone;money;mp three;wallet;watch;balloon;bottle opener;candle;coat hanger;comb;dice;flashlight;gun;magnet;suitcase;binoculars;kite;map;newspaper;passport;rucksack;shopping cart;straw;ticket;trashcan;";
        public static var body1:String = "arm;ear;eye;finger;foot;hand;leg;mouth;nose;teeth;hair;head;neck;toe;thumb;belly;chin;beard;bottom;tongue;";
        public static var body2:String = "shoulder;knee;moustache;elbow;forehead;heel;ankle;eyebrow;eyelash;wrist;armpit;belly button;bicep;bone;calf;earlobe;hip;lips;nostril;thigh;";
        public static var jobs:String = "chef;doctor;driver;farmer;fireman;nurse;policeman;soldier;teacher;waiter;shop assistant;singer;dancer;dentist;fisherman;builder;mechanic;factory worker;office worker;gardener;athlete;barman;security guard;reporter;receptionist;life guard;electrician;pirate;handyman;writer;";
        public static var animalparts:String = "beak;claw;feather;fin;horn;paw;tail;trunk;tusk;wings;";
        public static var clothes1:String = "coat;dress;hat;pants;shoe;shorts;skirt;socks;tie;tshirt;glasses;sweater;gloves;jacket;scarf;belt;suit;boots;ring;umbrella;";
        public static var clothes2:String = "helmet;swimsuit;sunglasses;sandals;vest;necklace;slipper;dressing gown;high heels;mask;axe;bracelet;cloak;crown;earring;flip flops;shield;snorkel;space suit;sword;";
        public static var city:String = "apartment block;castle;church;factory;hospital;lighthouse;palace;skyscraper;tent;windmill;bridge;bus stop;crossroads;fountain;road;sidewalk;statue;street light;track;traffic lights;";
        public static var colors:String = "red;blue;green;orange;yellow;purple;black;white;brown;grey;pink;gold;violet;silver;dark red;light red;dark blue;light blue;dark green;light green;";
        public static var furniture:String = "tv;chair;door;sofa;table;window;lamp;clock;bin;closet;telephone;picture;remote;air conditioner;rug;stairs;plant;curtain;vase;cushion;armchair;bookcase;ceiling;fan;floor;globe;shelf;fireplace;stereo;stool;";
        public static var positions:String = "in;on;under;above;in front of;behind;between;next to;on the right;on the left;";
        public static var verbs1:String = "be quiet;drink;eat;listen;look;run;sleep;smell;speak;walk;cook;dance;fly;jump;read;sing;sit;smile;stand;write;";
        public static var verbs2:String = "close the door;do homework;go shopping;listen to music;open a book;play video games;take a photo;talk on the phone;use a computer;wash hands;clean teeth;get dressed;get to school;get up;have breakfast;leave the house;take a bus;take a shower;wake up;wash your face;";
        public static var sports:String = "basketball;soccer;tennis;swimming;golf;table tennis;volley ball;chess;boxing;pool;cycling;baseball;cricket;bowling;poker;fishing;american football;rugby;hockey;wrestling;darts;diving;gymnastics;high jump;horse riding;javelin;long jump;pole vault;shooting;shot putt;";
		
		public static const ACH_FEARLESS:String = "ACH_FEARLESS";
		public static const ACH_COOL_START:String = "ACH_COOL_START";
		public static const ACH_PRETTY_QUICK:String = "ACH_PRETTY_QUICK";
		public static const ACH_KNOW_THEM_ALL:String = "ACH_KNOW_THEM_ALL";
		public static const ACH_FAST_HAND_MASTER:String = "ACH_FAST_HAND_MASTER";
		
		private static var listCat:Array;
		private static var listWords:Object;
		static private var GPLConstants:Object;	
		
		public function FasthandUtil() 
		{			
		}		
		
		public static function getListWords(cat:String):Array
		{
			if (!listWords)
				listWords = {};
			if (!listWords.hasOwnProperty(cat))
			{
				var arr:Array = FasthandUtil[cat].split(";");
				for (var i:int = 0; i < arr.length; i++) 
				{
					if (arr[i] == "")
					{
						arr.splice(i, 1);
						i--;
					}
				}
				listWords[cat] = arr;
			}
			return listWords[cat];
		}
		
		public static function getListCat():Array
		{
			if (!listCat || listCat.length < 1)
			{
				listCat = [];
				var xml:XML = describeType(FasthandUtil);				
				for each(var item:XML in xml.variable)
				{
					listCat.push(item.@name.toString());
				}
				listCat.sort();
			}				
			return listCat;
		}
		
		static public function getAchievementIOS(type:String):String
		{
			var retStr:String = "";
			var parts:Array = type.toLowerCase().split("_");
			var len:int = parts.length;
			for (var i:int = 0; i < len; i++) 
			{
				var s:String = parts[i];
				retStr += i == 0 ? s : (s.charAt(0).toUpperCase() + s.substr(1));
			}
			return retStr;
		}
		
		static public function getAchievementLabel(type:String):String
		{
			var retStr:String = "";
			var parts:Array = type.toLowerCase().split("_");
			var len:int = parts.length;
			for (var i:int = 0; i < len; i++) 
			{
				var s:String = parts[i];
				if (i == 0)
					continue;
				retStr += (i==1 ? "" : " ") + s.charAt(0).toUpperCase() + s.substr(1);
			}
			return retStr;
		}
		
		static public function getAchievementAndroid(type:String):String
		{
			if (!GPLConstants)	// init 
				getCatForGooglePlay("letters");
			var retStr:String = GPLConstants[type];
			return retStr;
		}
		
		static public function getCatForGooglePlay(cat:String):String 
		{
			if (!GPLConstants)
			{
				GPLConstants = { };
				GPLConstants.ACH_FEARLESS = 'CgkIw5jL5a4VEAIQIA';
				GPLConstants.ACH_COOL_START = 'CgkIw5jL5a4VEAIQIQ';
				GPLConstants.ACH_PRETTY_QUICK = 'CgkIw5jL5a4VEAIQIw';
				GPLConstants.ACH_KNOW_THEM_ALL = 'CgkIw5jL5a4VEAIQIg';
				GPLConstants.ACH_FAST_HAND_MASTER = 'CgkIw5jL5a4VEAIQJA';
				GPLConstants.LEAD_OVERALL = 'CgkIw5jL5a4VEAIQAw';
				GPLConstants.LEAD_ADJECTIVES = 'CgkIw5jL5a4VEAIQAQ';
				GPLConstants.LEAD_ANIMAL_1 = 'CgkIw5jL5a4VEAIQAg';
				GPLConstants.LEAD_ANIMAL_2 = 'CgkIw5jL5a4VEAIQBA';
				GPLConstants.LEAD_ANIMAL_PARTS = 'CgkIw5jL5a4VEAIQBQ';
				GPLConstants.LEAD_BODY_1 = 'CgkIw5jL5a4VEAIQBg';
				GPLConstants.LEAD_BODY_2 = 'CgkIw5jL5a4VEAIQBw';
				GPLConstants.LEAD_CITY = 'CgkIw5jL5a4VEAIQCA';
				GPLConstants.LEAD_CLOTHEST_1 = 'CgkIw5jL5a4VEAIQCQ';
				GPLConstants.LEAD_CLOTHEST_2 = 'CgkIw5jL5a4VEAIQCg';
				GPLConstants.LEAD_COLORS = 'CgkIw5jL5a4VEAIQCw';
				GPLConstants.LEAD_COMPUTERS = 'CgkIw5jL5a4VEAIQDA';
				GPLConstants.LEAD_FOOD_1 = 'CgkIw5jL5a4VEAIQDQ';
				GPLConstants.LEAD_FOOD_2 = 'CgkIw5jL5a4VEAIQDg';
				GPLConstants.LEAD_FURNITURE = 'CgkIw5jL5a4VEAIQDw';
				GPLConstants.LEAD_GARDEN = 'CgkIw5jL5a4VEAIQEA';
				GPLConstants.LEAD_HOSPITAL = 'CgkIw5jL5a4VEAIQEQ';
				GPLConstants.LEAD_JOBS = 'CgkIw5jL5a4VEAIQEg';
				GPLConstants.LEAD_KITCHEN = 'CgkIw5jL5a4VEAIQEw';
				GPLConstants.LEAD_LETTERS = 'CgkIw5jL5a4VEAIQFA';
				GPLConstants.LEAD_NATURE = 'CgkIw5jL5a4VEAIQFQ';
				GPLConstants.LEAD_NUMBERS_1 = 'CgkIw5jL5a4VEAIQFg';
				GPLConstants.LEAD_NUMBERS_2 = 'CgkIw5jL5a4VEAIQFw';
				GPLConstants.LEAD_PERSONAL = 'CgkIw5jL5a4VEAIQGA';
				GPLConstants.LEAD_POSITION = 'CgkIw5jL5a4VEAIQGQ';
				GPLConstants.LEAD_SPORTS = 'CgkIw5jL5a4VEAIQGg';
				GPLConstants.LEAD_STATIONARY = 'CgkIw5jL5a4VEAIQGw';
				GPLConstants.LEAD_TRANSPORT = 'CgkIw5jL5a4VEAIQHA';
				GPLConstants.LEAD_VERBS_1 = 'CgkIw5jL5a4VEAIQHQ';
				GPLConstants.LEAD_VERBS_2 = 'CgkIw5jL5a4VEAIQHg';
			}			
			var key:String = LangUtil.getText(cat);
			key = key.replace(" ", "_");
			key = "LEAD_" + key.toUpperCase();
			return GPLConstants[key];
		}
		
	}

}