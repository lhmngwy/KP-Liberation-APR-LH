/*
TPW FURNITURE - Ambient furniture on Tanoa
Version: 1.06
Author: tpw
Date: 20190623
Requires: CBA A3
Compatibility: SP, MP client (maybe)

Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works. 

To use: 
1 - Save this script into your mission directory as e.g. tpw_furniture.sqf
2 - Call it with 0 = [50,5] execvm "tpw_furniture.sqf";  where the numbers represent (in order):

50 = radius (m) around player to scan for houses to furnish
5 = time (sec) in between house scans
*/

if ((count _this) < 2) exitwith {player sidechat "TPW FURNITURE incorrect/no config, exiting."};
WaitUntil {!isNull FindDisplay 46};
 
// VARIABLES
tpw_furniture_version = "1.06"; // Version string
tpw_furniture_active = true; // Furniture active.
tpw_furniture_radius = _this select 0; // radius (m) around player to scan for houses to spawn furniture 
tpw_furniture_scantime = _this select 1; // time (sec) in between house scans

tpw_furniture_houses = []; // houses with furniture
tpw_furniture_lastpos = [0,0,0]; // last position of player

// FURNISH HOUSE
tpw_furniture_fnc_populate =
	{
	private ["_bld","_type","_items","_item","_offset","_angle","_bld","_pos","_spawned","_templates"];
	_bld = _this select 0;
	_type = typeof _bld;
	
	// Skip previously identified non houses
	if (_bld getvariable ["tpw_furnished",0] == -1) exitwith {};
	
	// Assign appropriate furnishing template for house			
	if (_bld getvariable ["tpw_furnished",0] == 0) then
		{
		switch _type do
			{
			// TANOA
			case "Land_House_Small_01_F":
				{
				_templates = [[["Land_TablePlastic_01_F",[-4.39307,1.2832,-0.699362],88.2366],["Land_ChairPlastic_F",[-5.41113,1.27539,-0.699363],4.16151],["Land_ChairPlastic_F",[-3.12256,0.893555,-0.699363],176.193],["Land_ChairPlastic_F",[-4.40723,3.01758,-0.699363],251.962],["Land_ChairPlastic_F",[-4.42139,-0.375977,-0.699363],79.3795],["Land_WoodenTable_large_F",[-4.95117,-3.03711,-0.699362],90.9798],["Land_WoodenCounter_01_F",[0.318848,2.27832,-0.699363],90.7001],["Land_WoodenTable_small_F",[1.84277,3.00781,-0.699362],181.198],["Land_ShelvesWooden_F",[1.47559,-1.9873,-0.699363],1.68573],["Land_Metal_rack_Tall_F",[6.17578,2.85449,-0.699363],-90.9498],["Land_ChairWood_F",[2.92529,3.0498,-0.699362],-9.95035],["Land_ChairWood_F",[1.91602,1.67285,-0.699362],144.447],["Fridge_01_closed_F",[5.9502,-3.23047,-0.699363],178.229],["Land_Basket_F",[1.72754,-3.37402,-0.699362],132.784],["Land_Sack_F",[5.79102,-1.53223,-0.699362],-54.0081],["Land_Sack_F",[5.9165,0.0205078,-0.699362],-4.26343],["Land_CratesShabby_F",[5.82422,1.44629,-0.699363],0.10672],["Land_PlasticCase_01_large_F",[0.361816,-1.42383,-0.699363],-0.384552]],[["Land_Rug_01_F",[-3.40186,0.012207,-0.699362],90.0139],["Land_Rug_01_Traditional_F",[3.57422,1.31152,-0.699363],-0.219666],["Land_TableBig_01_F",[-3.15137,3.24512,-0.699363],-0.457108],["Land_Sofa_01_F",[-5.76758,0.103516,-0.699363],-91.1863],["Land_ArmChair_01_F",[-3.65186,-3.31689,-0.699363],2.04109],["Land_ArmChair_01_F",[0.208496,-1.30273,-0.699363],90.237],["Land_TableSmall_01_F",[-3.37598,-0.0634766,-0.699362],181.977],["Land_ChairWood_F",[-1.5625,2.9541,-0.699363],-122.695],["Land_ChairWood_F",[-3.0957,2.18848,-0.699363],179.495],["Land_ChairWood_F",[-4.76025,2.89355,-0.699363],134.355],["Land_OfficeCabinet_01_F",[0.508301,1.62598,-0.699363],-88.9799],["Land_WoodenBed_01_F",[2.29395,-2.72656,-0.699363],179.302],["Land_RattanChair_01_F",[1.53223,3.18018,-0.699363],19.4255],["OfficeTable_01_new_F",[5.88477,1.15527,-0.699363],-88.4198],["Land_OfficeChair_01_F",[5.31055,1.44971,-0.699363],50.3321],["Fridge_01_closed_F",[5.88037,-3.57324,-0.699363],-91.4833],["Land_ShelvesWooden_F",[5.9082,-2.39795,-0.699363],-1.48329]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
				
			case "Land_House_Small_02_F":
				{
				_templates = [[["Land_PlasticCase_01_large_F",[-3.80566,0.600586,-0.714201],270.116],["Land_BarrelWater_F",[-4.06494,1.47998,-0.714201],212.719],["Land_BarrelWater_F",[-3.91357,4.53906,-0.714201],206.741],["Land_Sacks_heap_F",[-3.75098,5.45117,-0.714201],173.155],["Fridge_01_closed_F",[-0.367188,0.784668,-0.714201],178.862],["Land_Microwave_01_F",[0.33252,0.619141,-0.714201],191.194],["Land_ShelvesWooden_F",[-4.18115,3.19238,-0.714201],-0.175385],["Land_WoodenCounter_01_F",[-3.90479,-3.41016,-0.714201],268.449],["Land_WoodenTable_small_F",[-0.106934,-5.19629,-0.714201],179.695],["Land_RattanChair_01_F",[-1.24609,-5.4043,-0.714201],104.568],["Land_CampingChair_V1_F",[-0.227539,-3.08984,-0.714201],16.8977],["Land_ChairPlastic_F",[-1.15967,-4.07422,-0.714201],344.842]],[["Land_Rug_01_Traditional_F",[-1.85938,-3.63428,-0.715147],-89.8556],["Land_Rug_01_Traditional_F",[0.000976563,4.74414,-0.714962],-1.57393],["Land_Sofa_01_F",[-3.31787,5.51904,-0.713017],-180.564],["Land_TableSmall_01_F",[-3,3.09253,-0.713012],-178.699],["Land_ArmChair_01_F",[-3.57715,0.996826,-0.714393],-72.8791],["Land_ArmChair_01_F",[0.0112305,0.898682,-0.71539],1.42355],["Land_WoodenBed_01_F",[-0.450684,-5.19995,-0.715315],-88.5715],["Land_PlasticCase_01_large_F",[-3.42822,-5.55371,-0.715313],-88.794],["Land_LuggageHeap_02_F",[-3.8584,-4.36719,-0.713732],-180.211],["Land_ShelvesWooden_F",[-4.07178,-2.90527,-0.713739],-179.816],["Fridge_01_closed_F",[-4.20996,-0.482422,-0.713247],90.022],["Land_Microwave_01_F",[-4.31885,-1.64673,-0.713238],89.3825],["OfficeTable_01_new_F",[0.24707,3.25635,-0.715184],-92.3456],["Land_OfficeChair_01_F",[-0.842285,3.59448,-0.715184],-92.3456]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_House_Small_03_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-3.04688,-1.09473,-1.32258],-177.826],["Land_ChairWood_F",[-4.02051,-1.66113,-1.32258],102.879],["Land_ChairWood_F",[-3.95264,-0.40918,-1.32258],72.8789],["Land_ChairWood_F",[-2.96143,0.394531,-1.32258],1.36459],["Land_ShelvesWooden_F",[-2.70898,3.6416,-1.32258],-180.168],["Land_ShelvesWooden_F",[-3.58252,5.09668,-1.32258],-89.0166],["Fridge_01_closed_F",[-6.14307,5.00391,-1.32258],0.283615],["Land_BarrelWater_F",[-5.05859,4.875,-1.32258],-12.9616],["Land_PlasticCase_01_small_F",[-2.63818,2.64941,-1.32258],-0.86998],["Land_Sacks_goods_F",[-5.83984,2.27734,-1.32258],146.318],["Land_Sack_F",[-5.77539,0.879883,-1.32258],-183.514],["Land_Sack_F",[-5.87988,-1.62305,-1.32258],-74.1766],["Land_Sacks_heap_F",[2.4209,-1.18457,-1.32258],79.303],["Land_CanisterPlastic_F",[2.64453,0.347656,-1.32258],2.86423],["Land_GasTank_01_blue_F",[2.66113,1.92578,-1.32258],2.86423],["Land_Basket_F",[0.0766602,-1.71875,-1.32258],-7.47496],["Land_Basket_F",[-1.5332,2.85645,-1.32258],-140.148],["Land_Metal_rack_Tall_F",[-1.91113,4.40332,-1.32258],91.9407],["Land_Metal_rack_Tall_F",[0.318359,4.99023,-1.32258],-1.69688]],[["Land_Rug_01_F",[0.255371,0.98877,-1.32258],-90.909],["Land_Rug_01_F",[-4.66602,3.7373,-1.32258],89.1189],["Land_Rug_01_Traditional_F",[-4.65381,0.0288086,-1.32258],88.7058],["Land_TableBig_01_F",[-0.373535,4.89551,-1.32258],-0.890472],["Land_RattanChair_01_F",[-1.81934,4.86523,-1.32258],-220.909],["Land_RattanChair_01_F",[-0.324219,3.88184,-1.32258],-175.498],["Land_RattanChair_01_F",[1.15137,4.88623,-1.32258],-32.1837],["Land_Sofa_01_F",[2.62988,0.216309,-1.32258],91.0139],["Land_ArmChair_01_F",[-1.69678,-0.0371094,-1.32258],-85.5847],["Land_TableSmall_01_F",[0.335449,1.00635,-1.32258],-90.0636],["Land_WoodenBed_01_F",[-3.54785,-1.38428,-1.32258],-88.4023],["Land_TableDesk_F",[-6.06445,-1.42334,-1.32258],-90.1579],["Land_LuggageHeap_01_F",[-5.34717,-1.57373,-1.32258],-101.37],["Land_Basket_F",[-5.9082,4.93457,-1.32258],-214.01],["Fridge_01_closed_F",[-4.18652,4.91504,-1.32258],-0.66597],["Land_BarrelWater_F",[-3.52783,4.91016,-1.32258],5.92471],["Land_Metal_rack_Tall_F",[-2.79639,3.50439,-1.32258],-89.216]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_House_Small_04_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-1.66309,-3.93457,-0.864875],-180.002],["Land_RattanChair_01_F",[-0.495117,-4.66602,-0.86476],-185.523],["Land_RattanChair_01_F",[-0.614258,-3.41992,-0.864752],-95.9327],["Land_RattanChair_01_F",[-1.5791,-2.18408,-0.86497],-10.4366],["Land_WoodenCounter_01_F",[3.91211,-2.41406,-0.86588],91.3104],["Land_ShelvesWooden_F",[0.543945,1.9248,-0.865171],-174.964],["Land_Sacks_goods_F",[0.27002,3.65137,-0.86414],-63.6292],["Land_Basket_F",[0.648438,0.700684,-0.865187],-115.737]],[["Land_TableBig_01_F",[3.80811,-2.6748,-0.864767],-89.4794],["Land_Rug_01_Traditional_F",[0.755859,-2.7041,-0.864767],-89.4794],["Land_Sofa_01_F",[-1.80908,-3.48975,-0.864767],-88.836],["Land_ArmChair_01_F",[0.0322266,-4.18359,-0.864767],1.85329],["Land_TableSmall_01_F",[-0.332031,-3.20459,-0.864767],-4.33629],["Land_RattanChair_01_F",[2.41162,-1.94971,-0.864767],63.2565],["Land_RattanChair_01_F",[2.77783,-2.98242,-0.864767],84.5115],["Land_RattanChair_01_F",[3.29785,-0.833984,-0.864767],-92.9179],["Land_Metal_rack_F",[0.641602,1.64697,-0.864767],-89.804],["Land_WoodenCounter_01_F",[-1.8877,2.5708,-0.864767],87.8617],["Fridge_01_closed_F",[0.631348,3.99805,-0.864767],-0.528275],["Land_CanisterPlastic_F",[0.61377,2.75684,-0.864767],-8.29608]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
				
			case "Land_House_Small_06_F":
				{
				_templates = [[["Land_TablePlastic_01_F",[-1.41699,-4.63379,-1.00068],-178.977],["Land_ChairPlastic_F",[0.0175781,-3.98975,-1.00068],-132.682],["Land_ChairPlastic_F",[-2.93457,-3.97656,-1.00068],-32.8382],["Land_ChairPlastic_F",[-1.40234,-3.51807,-1.00068],-84.6655],["Land_WoodenTable_large_F",[-2.25391,1.56348,-1.00068],-88.8574],["Land_WoodenCounter_01_F",[1.86621,-3.7085,-1.00068],91.8469],["Land_Metal_rack_F",[2.27832,0.189453,-1.00068],-90.243],["Land_Basket_F",[-4.02246,1.79492,-1.00068],45.8277],["Land_Sack_F",[-3.87305,0.850586,-1.00068],77.0597],["Land_Sack_F",[-4.0918,-0.185547,-1.00068],-177.337],["Land_PlasticCase_01_small_F",[-3.97559,-5.03857,-1.00068],-89.3508],["Land_CanisterFuel_F",[-3.97266,-4.03271,-1.00068],-53.4766]],[["Land_Rug_01_F",[-3.28125,-1.21826,-0.999801],180.424],["Land_TableBig_01_F",[1.8623,-4.10254,-1.00027],-89.1246],["Land_Sofa_01_F",[-1.29785,-4.61914,-0.999863],-1.54855],["Land_ArmChair_01_F",[0.00244141,-2.70703,-0.999863],148.451],["Land_ArmChair_01_F",[-4.02344,-3.9209,-0.999736],-80.4834],["Land_WoodenTable_small_F",[-3.80273,1.30859,-1.0013],91.8792],["Land_CampingChair_V2_F",[-1.75684,1.37549,-1.0013],151.879],["Land_ChairPlastic_F",[-3.59326,-0.00683594,-1.00018],-137.959],["Land_OfficeCabinet_01_F",[2.15723,0.254883,-1.00156],-91.3043],["Land_RattanChair_01_F",[0.912109,-4.72949,-0.999984],159.835],["Land_RattanChair_01_F",[0.828125,-3.61719,-0.999984],-80.1649]]	];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			case "Land_House_Big_01_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[2.51563,1.57227,-1.01143],-180.482],["Land_ChairWood_F",[1.22559,1.70557,-1.01143],93.6551],["Land_ChairWood_F",[2.63184,2.96729,-1.01143],10.7773],["Land_ChairWood_F",[3.37012,1.15137,-1.01143],-79.5892],["Land_WoodenCounter_01_F",[7.20313,2.05859,-1.01143],87.9852],["Land_ShelvesWooden_F",[4.16992,5.7085,-1.01143],-92.8692],["Fridge_01_closed_F",[0.169922,5.68506,-1.01143],1.6033],["Land_Basket_F",[7.26465,-1.00049,-1.01143],-172.424],["Land_CratesShabby_F",[5.89941,-0.901855,-1.01143],-0.59993],["Land_Sack_F",[5.00977,-1.01514,-1.01143],-40.0437],["Land_BarrelWater_F",[7.30469,3.63818,-1.01143],77.9324],["Land_PlasticCase_01_large_F",[0.0273438,2.56982,-1.01143],-182.23]],[["Land_WoodenBed_01_F",[0.710938,4.76221,-1.01143],0.962708],["Land_Rug_01_Traditional_F",[2.72656,0.989746,-1.01143],179.307],["Land_TableBig_01_F",[1.01563,0.796387,-1.01143],90.4596],["Land_RattanChair_01_F",[1.17578,2.4541,-1.01143],0.708405],["OfficeTable_01_new_F",[3.8457,5.65723,-1.01143],-2.09335],["Land_OfficeChair_01_F",[3.66602,4.84766,-1.01143],179.009],["Land_Sofa_01_F",[6.49609,-0.467285,-1.01143],28.7335],["Land_ArmChair_01_F",[7.08984,2.27637,-0.871851],152.61],["Land_TableSmall_01_F",[6.02734,1.04639,-1.01143],185.801],["Fridge_01_closed_F",[3.80664,-1.13574,-1.01143],179.051],["Land_LuggageHeap_01_F",[2.27734,5.63184,-1.01143],295.002],["Land_ShelvesWooden_F",[7.48828,4.69434,-1.01143],176.892]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_House_Big_02_F":
				{
				_templates = [[["Land_PlasticCase_01_large_F",[-5.98486,8.17578,-1.44058],180.522],["Land_CanisterFuel_F",[-6.03906,9.34473,-1.44053],136.607],["Land_ShelvesMetal_F",[-3.99219,9.05273,-1.44107],88.2645],["Land_Metal_rack_F",[-4.9082,0.816406,-1.44189],-88.5925],["OfficeTable_01_new_F",[-8.08594,3.51758,-1.4409],-5.07813],["Land_OfficeChair_01_F",[-8.14063,2.46973,-1.44077],-114.886],["Land_OfficeCabinet_01_F",[-9.00439,-0.982422,-1.44071],180.356],["Land_OfficeCabinet_01_F",[-0.245117,1.78418,-1.44048],89.8227],["Land_ChairWood_F",[3.25244,3.43164,-1.44094],6.48524],["Land_ChairWood_F",[4.23975,3.52734,-1.44171],-40.5042],["Land_GasTank_01_blue_F",[-1.80469,8.89453,-1.44106],-1.05878],["Land_CanisterPlastic_F",[-1.02783,9.1543,-1.44078],18.5195]],[["Land_ShelvesMetal_F",[-1.88379,5.03711,-1.44146],88.5099],["Land_CampingChair_V2_F",[-5.99121,9.18066,-1.44145],-2.12263],["Land_CanisterPlastic_F",[-3.37793,5.08301,-1.44146],92.5924],["Land_CanisterFuel_F",[-4.22363,5.04883,-1.44146],157.266],["Land_PlasticCase_01_small_F",[-6.01367,8.1709,-1.44145],176.831],["Land_BarrelWater_F",[-5.16992,9.24609,-1.44146],136.887],["Land_GasTank_01_blue_F",[-4.23926,9.06738,-1.44146],119.483],["Land_Rug_01_F",[2.67285,2.30566,-1.44146],-88.1137],["Land_Rug_01_F",[-9.81836,2.60156,-1.44146],-1.85278],["Land_OfficeChair_01_F",[-9.15625,2.3418,-1.44146],-65.705],["Land_OfficeCabinet_01_F",[-7.30078,3.63477,-1.44146],0.45369],["Land_Sofa_01_F",[-5.55957,-0.133789,-1.44146],60.6761],["Land_CratesShabby_F",[-3.15918,9.21191,-1.44146],-59.6573]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_House_Big_03_F":
				{
				_templates = [[["Land_BarrelWater_F",[2.34912,-5.07373,-3.17353],-206.69],["Land_PlasticCase_01_large_F",[2.0957,-3.8335,-3.17353],-179.769],["Land_CanisterFuel_F",[2.41699,-2.58105,-3.17353],-197.168],["Land_CanisterFuel_F",[2.44434,-1.86084,-3.17353],-167.169],["Land_Metal_rack_Tall_F",[3.46826,-0.779785,-3.17353],2.39783],["Land_Metal_rack_Tall_F",[4.4751,-0.949707,-3.17353],-0.0993805],["Land_TablePlastic_01_F",[9.5,0.535156,-3.17353],-181.059],["Land_ChairPlastic_F",[10,1.60742,-3.17353],-123.364],["Land_ChairPlastic_F",[8.32559,0.975098,-3.17353],-9.52327],["Land_ShelvesWooden_F",[1.60938,3.69238,-3.17353],-90.8741],["Land_OfficeCabinet_01_F",[3.71582,3.78906,-0.0890994],-2.41085],["Land_RattanChair_01_F",[3.49951,-2.45996,-0.0890989],-230.299],["Land_RattanChair_01_F",[5.23145,-2.48486,-0.0890989],-185.076],["Land_Sleeping_bag_folded_F",[7.32861,3.19482,-0.0890989],-308.796],["Land_Ground_sheet_folded_blue_F",[7.83594,2.91748,-0.0890994],39.2727],["Land_LuggageHeap_02_F",[6.19922,3.49609,-0.0890989],-288.367],["Land_LuggageHeap_03_F",[7.05762,-2.4668,-0.0890994],-141.923]],[["Land_Metal_rack_Tall_F",[1.85596,-2.75293,-3.17352],87.7463],["Land_CratesShabby_F",[2.3501,-5.35938,-3.17353],122.549],["Land_BarrelWater_F",[2.12061,-4.38867,-3.17352],103.525],["Land_CanisterPlastic_F",[1.91553,-0.804688,-3.17353],17.4753],["Land_CanisterFuel_F",[2.46484,-0.765625,-3.17353],-43.572],["Land_GasTank_01_blue_F",[1.89697,-1.21484,-3.17353],51.8746],["Land_CampingChair_V2_F",[3.32275,-5.22266,-3.17352],132.627],["Land_BottlePlastic_V2_F",[2.64111,-4.83496,-3.17352],109.63],["Land_ChairPlastic_F",[10.8599,5.86035,-0.110208],-49.4272],["Land_ArmChair_01_F",[7.80518,2.90234,-0.089098],123.288],["Land_ArmChair_01_F",[8.20752,-2.47559,-0.0890989],57.9177],["Land_Sofa_01_F",[3.81152,3.47461,-0.089098],-181.224],["Land_TableSmall_01_F",[4.28955,-1.98535,-0.089097],-89.8221],["Land_RattanChair_01_F",[5.25391,-2.02344,-0.089097],-91.1164],["Land_RattanChair_01_F",[3.33691,-2.05469,-0.089098],95.0938],["Land_ChairPlastic_F",[10.9297,-5.51758,-0.110209],50.8832],["Land_Rug_01_Traditional_F",[9.04541,1.87402,-3.17352],-177.418],["Land_Rug_01_Traditional_F",[5.82715,2.53027,-3.17352],-181.922],["Land_PlasticCase_01_large_F",[8.86182,0.373047,-3.17352],-93.3301],["Land_PlasticCase_01_large_F",[4.90479,3.56738,-3.17352],92.4592],["Land_LuggageHeap_02_F",[5.75977,0.505859,-3.17352],-173.248],["Land_LuggageHeap_01_F",[4.49316,0.673828,-3.17352],-173.248],["Land_LuggageHeap_03_F",[8.92529,3.12305,-3.17352],-19.6864]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		
				
			case "Land_House_Big_04_F":
				{
				_templates = [[["Land_Sleeping_bag_blue_F",[-5.67578,2.2915,0.301346],1.78235],["Land_Pillow_old_F",[-5.51465,4.83984,0.302036],27.523],["Land_ShelvesWooden_F",[-2.45117,4.20264,0.301067],-91.9971],["Land_Sleeping_bag_blue_folded_F",[-5.65039,4.24902,0.301777],-11.0885],["Land_Sleeping_bag_F",[3.95215,3.87979,0.303612],179.422],["Land_Pillow_grey_F",[4.00977,2.03955,0.302792],204.04],["Land_Pillow_grey_F",[3.92871,2.64697,0.303185],192.524],["Land_Sleeping_bag_folded_F",[4.23535,2.05908,0.303478],183.55],["Land_Ground_sheet_folded_blue_F",[2.24512,4.5376,0.302521],212.019],["Land_CampingChair_V1_F",[2.73438,2.56836,0.303806],173.04],["Land_CampingChair_V1_F",[3.13574,3.7959,0.302563],-74.2686],["Land_CampingTable_small_F",[-2.37109,2.02344,0.304775],176.863],["Land_TablePlastic_01_F",[3.61816,-2.25684,-2.94675],-94.3656],["Land_ChairPlastic_F",[2.48047,-1.13037,-2.94786],-61.4986],["Land_ChairPlastic_F",[2.13477,-2.30713,-2.94786],-16.4986],["Land_ChairPlastic_F",[2.44922,-3.58545,-2.94786],43.5013],["Land_WoodenTable_large_F",[-3.94727,-4.12549,-2.94534],-89.8305],["Land_WoodenCounter_01_F",[-0.922852,-0.937988,-2.94878],183.926]],[["Land_WoodenBed_01_F",[-5.40771,1.7793,0.303832],89.4172],["Land_WoodenBed_01_F",[3.52637,4.04785,0.301876],-91.1371],["Land_Rug_01_F",[-0.851074,3.91016,0.30286],-0.266739],["Land_TableSmall_01_F",[3.65869,2.46777,0.301877],-92.0868],["Land_TableSmall_01_F",[-5.82373,3.16309,0.303832],90.6225],["Land_RattanChair_01_F",[-2.38672,1.56543,0.302321],-162.469],["Land_RattanChair_01_F",[-3.45898,1.62793,0.302865],163.832],["Land_OfficeCabinet_01_F",[1.87939,1.05957,0.302666],175.616],["OfficeTable_01_old_F",[-2.53076,4.50977,0.303125],0.532089],["Land_OfficeChair_01_F",[-4.14063,4.20703,0.303605],34.6951],["Land_LuggageHeap_03_F",[-5.81055,4.2373,0.303766],53.2846],["Fridge_01_closed_F",[2.83447,1.20215,0.302585],-179.488]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			case "Land_Slum_01_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[5.16748,0.111328,0.670929],-0.11588],["Land_WoodenCounter_01_F",[1.82422,2.00293,0.669987],-180.655],["Land_ChairWood_F",[4.75977,-1.7666,0.670929],-219.372],["Land_ChairWood_F",[4.27051,-0.113281,0.670929],-265.684],["Land_CampingChair_V1_F",[5.18213,1.84082,0.670895],-312.999],["Land_Basket_F",[3.20801,-1.6582,0.670658],-12.1951],["Land_Basket_F",[2.38818,-1.66504,0.670658],-327.195],["Land_CratesShabby_F",[-0.475195,0.363281,0.668991],-93.0426]],[["Land_WoodenBed_01_F",[4.59961,-0.964722,0.669953],-179.444],["Land_Sofa_01_F",[1.11426,1.41559,0.669953],-185.967],["Land_Rug_01_Traditional_F",[0.84375,-0.277527,0.669954],87.9373],["Land_TableBig_01_F",[4.07324,1.81262,0.669954],-182.933],["Land_ChairWood_F",[3.95215,0.659912,0.669953],-187.457],["Land_ChairWood_F",[2.99219,0.680969,0.669954],-142.438],["Land_Metal_rack_Tall_F",[2.04492,-2.16064,0.669953],-176.843],["Land_LuggageHeap_02_F",[2.8623,-1.67554,0.669953],-165.03]]	];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
				
			case "Land_Slum_02_F":
				{
				_templates = [[["Land_Basket_F",[-2.24756,4.38965,0.18475],194.435],["Land_CratesShabby_F",[-0.16084,4.42344,0.18454],182.289],["Land_Sack_F",[0.816406,4.2041,0.184204],161.705],["Land_Sack_F",[1.7666,4.26563,0.183887],92.0912],["Land_Sacks_goods_F",[1.93262,1.24023,0.183758],59.8842],["Land_BarrelWater_F",[-1.23413,4.33203,0.184875],187.171],["Land_Sacks_heap_F",[-2.12378,-3.71875,0.185604],-83.6961],["Land_WoodenTable_large_F",[1.89355,-3.18945,0.184761],2.58131],["Land_RattanChair_01_F",[0.328125,-2.64746,0.184475],19.4736]],[["Land_WoodenBed_01_F",[1.64063,-3.37158,0.184655],179.236],["Land_Rug_01_F",[-0.483398,0.660156,0.184655],180.354],["Land_TableBig_01_F",[-0.0400391,4.2627,0.184655],0.259308],["Land_Sofa_01_F",[2.21484,1.52661,0.184655],90.1538],["Land_TableSmall_01_F",[0.911133,1.0896,0.184655],182.56],["Land_Sofa_01_F",[-0.0976563,1.61084,0.184655],272.56],["Land_WoodenCounter_01_F",[-2.13965,-3.21094,0.184655],269.154],["Land_Basket_F",[-2.29688,-1.33032,0.184655],234.759],["Land_Basket_F",[-2.02734,-0.225586,0.184655],-35.2412]]	];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
	
			case "Land_Slum_03_F":
				{
				_templates = [[["Land_TablePlastic_01_F",[-2.72852,5.0791,-0.648022],-89.7099],["Land_ChairPlastic_F",[-1.53516,5.33008,-0.648022],-178.257],["Land_ChairPlastic_F",[-4.05469,5.4873,-0.648018],-40.9423],["Land_ShelvesWooden_F",[0.0556641,3.10107,-0.648018],-181.728],["Land_ShelvesWooden_F",[0.93457,3.46484,-0.648018],0.227974],["Land_WoodenCounter_01_F",[5.0625,4.6123,-0.648018],-91.0826],["Land_WoodenCounter_01_F",[5.21387,1.49121,-0.648022],89.7324],["Land_ChairWood_F",[1.37012,2.55762,-0.648022],53.3668],["Land_Metal_rack_F",[-4.97949,1.00342,-0.648018],91.9733],["Fridge_01_closed_F",[-4.80371,-0.822266,-0.648018],90.3232],["Land_Basket_F",[-0.386719,1.2207,-0.648014],-71.3866],["Land_Basket_F",[0.227539,-1.51172,-0.648018],-105.558],["Land_Sack_F",[-1.11328,-1.46484,-0.648018],-117.807],["Land_CanisterPlastic_F",[-4.8623,0.0283203,-0.648018],-223.503]],[["Land_WoodenBed_01_F",[-4.16553,6.39453,-0.648015],-1.04827],["Land_WoodenBed_01_F",[-0.821289,3.01807,-0.648015],-87.9529],["Land_Rug_01_Traditional_F",[-0.811035,5.49292,-0.648016],76.9964],["Land_Rug_01_Traditional_F",[-2.61963,-0.452881,-0.648015],-179.895],["Land_Rug_01_F",[3.37939,5.20093,-0.648015],-1.0584],["Land_Rug_01_F",[3.70313,0.511963,-0.648015],90.0032],["Land_ChairWood_F",[-4.08496,3.18726,-0.648015],114.048],["Land_PlasticCase_01_large_F",[-2.07861,7.2229,-0.648015],93.0647],["Land_LuggageHeap_02_F",[-0.0981445,7.24609,-0.648015],59.4464],["Fridge_01_closed_F",[-4.56055,-1.31543,-0.648015],-180.927],["Land_ShelvesWooden_F",[-4.68896,1.11206,-0.648015],-182.614],["Land_Basket_F",[-3.55176,1.21851,-0.648015],-227.117],["Land_Sacks_goods_F",[-0.538086,1.22583,-0.648015],35.6077],["Land_Sack_F",[0.0200195,-1.36963,-0.648015],-33.7397],["Land_Metal_rack_Tall_F",[1.11133,1.86792,-0.648015],90.7941],["Land_Metal_rack_Tall_F",[1.14355,3.05469,-0.648015],91.1905],["Land_RattanChair_01_F",[3.40625,7.33545,-0.648015],16.1905],["Land_TableBig_01_F",[3.30127,5.53076,-0.648015],-0.282593],["Land_ChairWood_F",[1.60547,6.13403,-0.648015],23.9493],["Land_ChairWood_F",[4.70752,6.18188,-0.648015],-26.1703],["Land_ChairWood_F",[3.14844,3.90991,-0.648015],-32.8453],["Land_Sofa_01_F",[5.1709,1.24048,-0.648015],88.2229],["Land_ArmChair_01_F",[1.34961,-0.899902,-0.648015],-35.4429],["Land_ArmChair_01_F",[2.86133,2.26221,-0.648015],-113.421]]	];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			case "Land_Shop_Town_01_F":
				{
				_templates =[[["Land_Icebox_F",[-4.02148,-2.92139,-3.24347],92.0958],["Land_Icebox_F",[-4.01514,-0.605957,-3.24347],91.9758],["Land_CashDesk_F",[-3.63477,1.08691,-3.2425],1.15862],["Land_Metal_rack_F",[-0.268555,1.41748,-3.2439],-88.9577],["Land_Metal_rack_F",[-0.209473,0.241211,-3.2439],-88.9535],["Land_ShelvesMetal_F",[1.79053,-2.99609,-3.24393],-90.3454],["Land_ShelvesMetal_F",[-1.69922,-1.50049,-3.24249],2.89784],["Land_TableDesk_F",[-3.65967,3.18359,-3.24315],1.18808],["Land_OfficeChair_01_F",[-3.87695,3.93604,-3.24315],1.18808],["Land_OfficeCabinet_01_F",[-4.13379,5.90625,-3.2425],-6.17105],["Land_OfficeCabinet_01_F",[-4.12402,5.80615,-3.2425],-6.57448]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_Shop_Town_03_F":
				{
				_templates = [[["Land_CashDesk_F",[-4.51416,-0.11377,-3.35822],88.245],["Land_CashDesk_F",[-5.7417,-2.50293,-3.35822],2.76701],["Land_ShelvesMetal_F",[-4.13916,-3.99219,-3.35822],-90.0966],["Land_ShelvesMetal_F",[1.99072,-2.77979,-3.35822],-91.7501],["Land_Metal_rack_Tall_F",[1.14795,0.425293,-3.35822],-181.658],["Land_Metal_rack_Tall_F",[1.99951,0.310547,-3.35822],-181.658],["Land_Metal_rack_Tall_F",[3.08252,-0.0102539,-3.35822],-181.658],["Land_Metal_rack_Tall_F",[3.34668,0.628418,-3.35822],-180.214],["Land_WoodenTable_large_F",[3.18701,7.49609,-3.35822],-92.3368],["Land_RattanChair_01_F",[4.92383,7.3877,-3.35822],-125.48],["Land_RattanChair_01_F",[3.53467,6.17627,-3.35822],-170.404],["Land_RattanChair_01_F",[1.50439,7.26758,-3.35822],128.518],["Land_TableDesk_F",[-5.30029,5.56934,-3.35822],1.22641],["Land_OfficeChair_01_F",[-5.50342,6.6001,-3.35822],8.76091],["Land_OfficeCabinet_01_F",[-5.7002,7.90625,-3.35822],-2.53249],["OfficeTable_01_old_F",[6.34082,5.22998,-3.35822],-93.0884],["OfficeTable_01_new_F",[3.23145,1.646,-3.35822],-184.151],["Land_Metal_rack_F",[0.870605,5.06982,-3.35822],-178.752],["Land_Icebox_F",[-2.07568,5.62793,-3.35822],-178.809],["Land_Icebox_F",[-0.550293,-5.00488,-3.35822],89.9525],["Land_Icebox_F",[-0.522461,-2.87158,-3.35822],90.7582]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		
			case "Land_Addon_04_F":
				{
				_templates =[[["Land_WoodenTable_large_F",[-3.38135,-5.85889,0.33478],-181.111],["Land_RattanChair_01_F",[-1.97217,-4.83008,0.334781],-102.221],["Land_RattanChair_01_F",[-3.24219,-4.17725,0.334781],-12.221],["Land_RattanChair_01_F",[-2.04248,-6.18262,0.334781],-70.9686],["Land_Metal_rack_F",[-1.40381,-1.99,0.33478],-0.606853],["Land_Metal_rack_F",[-0.146973,-3.12207,0.33478],-91.441],["Land_ShelvesWooden_F",[-0.491211,-0.6875,0.334781],-271.279],["Land_ShelvesWooden_F",[-2.59473,-0.38623,0.33478],-269.897],["Land_TableDesk_F",[-0.905762,2.18145,0.33478],-184.208],["Land_OfficeChair_01_F",[-1.00391,1.38105,0.334781],-180.406],["Land_OfficeCabinet_01_F",[-3.23145,2.68457,0.33478],0.135162],["Fridge_01_closed_F",[3.08838,-6.56494,0.33478],-180.871],["Land_LuggageHeap_01_F",[3.38721,-1.77637,0.33478],-73.5685],["Land_Sack_F",[3.28857,-2.854,0.33478],-113.351],["Land_Sack_F",[3.44336,-0.586426,0.33478],-38.3514]],[["Land_ArmChair_01_F",[-2.73145,-0.722656,0.33478],-50.708],["Land_ArmChair_01_F",[-2.77295,1.39111,0.33478],-100.487],["Land_Sofa_01_F",[-0.874023,1.79932,0.33478],-178.982],["Land_Rug_01_Traditional_F",[-0.292969,0.125488,0.334781],-95.4532],["Land_TableSmall_01_F",[-0.292969,0.125488,0.334781],-95.4532],["Land_Rug_01_Traditional_F",[1.82471,-4.14453,0.33478],-180.544],["Land_PlasticCase_01_large_F",[3.03223,-7.26953,0.33478],-93.3149],["Land_PlasticCase_01_large_F",[1.60059,-7.13574,0.33478],-118.192],["Land_BarrelWater_F",[3.40771,-2.45557,0.334781],-40.337],["Land_Sleeping_bag_folded_F",[3.02539,-3.80371,0.33478],-81.3547],["Land_Rug_01_F",[-1.78662,-3.25537,0.334781],-270.566],["Land_WoodenBed_01_F",[-3.04199,-6.30908,0.33478],-180.143],["Land_Suitcase_F",[-0.494629,-2.77783,0.334781],33.5523],["Land_LuggageHeap_03_F",[-0.836914,-3.91992,0.33478],-4.72792]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];	
				};
				
			case "Land_Shed_02_F":
				{
				_templates =[[["Land_WoodenCounter_01_F",[-0.00976563,1.8501,-0.842734],-177.057],["Land_CratesShabby_F",[-1.3418,-0.608398,-0.842641],-90.3033],["Land_Sack_F",[-1.20801,0.197266,-0.844222],-90.3033],["Land_Sacks_goods_F",[1.09668,0.0151367,-0.84166],93.0307],["Land_BarrelWater_F",[-0.342773,0.876953,-0.840778],169.975]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];	
				};
			case "Land_Shed_05_F":
				{
				_templates =[[["Land_BarrelWater_F",[2.3125,0.800049,-0.889773],109.25],["Land_BarrelWater_F",[1.51172,0.887695,-0.889514],128.637],["Land_BarrelWater_F",[2.22656,-0.11377,-0.889867],100.362],["Land_Sacks_heap_F",[1.88867,-2.00049,-0.889935],-3.34731],["Land_Sacks_goods_F",[-0.396484,-1.62842,-0.889215],-13.3177],["Land_Sack_F",[-2.1875,-1.99268,-0.889215],16.6823],["Land_Sack_F",[-2.22559,-0.733398,-0.889215],61.6823],["Land_CratesShabby_F",[-2.09863,0.696289,-0.888219],-6.40511]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];		
				};				
			case "Land_House_Native_01_F":
				{
				_templates =[[["Land_WoodenTable_large_F",[0.0751953,-2.52881,-3.10103],269.414],["Land_WoodenTable_large_F",[1.85938,2.69238,-3.10103],91.0994],["Land_WoodenCounter_01_F",[-2.38672,2.80322,-3.10103],181.892],["Land_ShelvesWooden_F",[4.54688,-2.36328,-3.10103],1.38248],["Land_Basket_F",[-4.11133,-2.5498,-3.10104],271.682],["Land_Basket_F",[-4.18555,-1.62793,-3.10104],215.249],["Land_Basket_F",[-4.15918,2.49072,-3.10103],129.287],["Land_Basket_F",[-3.19238,-2.20068,-3.10104],175.117],["Land_Sack_F",[3.98926,2.81201,-3.10103],85.6202],["Land_Sack_F",[4.28418,1.74951,-3.10103],91.3261]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];	
				};						
				
			case "Land_House_Native_02_F":
				{
				_templates =[[["Land_Sack_F",[-3.24023,-1.93457,-2.41429],-100.074],["Land_Sack_F",[-3.48877,-0.839844,-2.41426],-55.0739],["Land_Sack_F",[-2.48633,-2.27539,-2.41417],-28.9239],["Land_Sacks_goods_F",[-3.24463,1.97168,-2.41522],171.087],["Land_BarrelWater_F",[-3.35498,0.00195313,-2.41447],236.356],["Land_BarrelWater_F",[-3.36182,0.755859,-2.41472],214.608],["Land_PlasticCase_01_small_F",[2.17871,-2.04199,-2.41458],-1.12192],["Land_PlasticCase_01_large_F",[2.01074,2.2832,-2.41551],89.1053],["Land_Sacks_heap_F",[-2.15967,-0.821289,-2.41423],-93.3029],["Land_ShelvesWooden_F",[0.0366211,-2.35352,-2.41423],-90.927],["Land_ShelvesWooden_F",[0.385742,2.13867,-2.41515],-92.6277]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];		
				};
			case "Land_Temple_Native_01_F":
				{
				_templates =[[["Land_WoodenTable_large_F",[-0.677246,1.06348,-6.03026],-93.4569],["Land_WoodenTable_large_F",[2.14404,4.15039,-6.03032],-89.1357],["Land_ChairWood_F",[-0.0981445,2.31152,-6.03183],-327.626],["Land_ChairWood_F",[0.677734,3.97559,-6.0314],-22.2716],["Land_ChairWood_F",[-2.41064,4.08398,-6.03172],-350.186],["Land_PlasticCase_01_large_F",[3.31055,0.351563,-6.02989],-0.0747254],["Land_PlasticCase_01_large_F",[-0.475586,4.74121,-6.03105],-269.639],["Land_BarrelWater_F",[-3.13477,-0.28418,-6.03091],-104.991]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];	
				};				
							
			case "Land_GarageShelter_01_F":
				{
				_templates =[[["Land_GasTank_01_blue_F",[3,3.36523,-1.25335],-1.62805],["Land_GasTank_01_blue_F",[3.74707,3.41357,-1.25335],-110.703],["Land_CanisterPlastic_F",[4.40186,3.12451,-1.25335],92.5223],["Land_CanisterFuel_F",[4.37354,1.35156,-1.25335],182.435],["Land_CanisterFuel_F",[4.17676,0.217773,-1.25335],12.169],["Land_PlasticCase_01_small_F",[-3.58887,3.38428,-1.25334],90.1638],["Land_PlasticCase_01_large_F",[-2.2583,3.2334,-1.25334],90.1638],["Land_BarrelWater_F",[-4.08887,-1.05713,-1.25334],160.904],["Land_BarrelWater_F",[-4.01514,-0.212891,-1.25334],160.606],["Land_BarrelWater_F",[-3.50928,-0.770508,-1.25334],197.629],["Land_Sacks_heap_F",[-0.942383,-1.95947,-1.25335],-86.1983],["Land_Sacks_goods_F",[-3.62988,1.28564,-1.25335],165.204],["Land_ShelvesMetal_F",[-0.811035,0.334473,-1.25335],1.38748]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];	
				};					
			case "Land_FuelStation_02_workshop_F":
				{
				_templates =[[["Land_Icebox_F",[0.836914,1.66797,-1.25639],-269.88],["Land_CashDesk_F",[4.02637,5.42383,-1.25439],-3.15121],["Land_Metal_rack_F",[4.57813,3.23926,-1.25583],-92.1851],["Land_Metal_rack_F",[4.53906,1.61719,-1.25578],-90.1576],["Land_Metal_rack_F",[4.53906,0.0371094,-1.25577],-90.1576],["Land_ShelvesMetal_F",[2.86035,0.87207,-1.25439],-0.543427]]];	
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];		
				};	
			case "Land_i_Shed_Ind_F":
				{
				_templates = [[["Land_OfficeCabinet_01_F",[-5.13623,-1.49902,-1.42244],-183.967],["Land_TableDesk_F",[-5.35254,0.597656,-1.42244],-269.581],["Land_OfficeChair_01_F",[-6.17578,0.612305,-1.42244],-252.334],["OfficeTable_01_new_F",[-8.49023,-0.0800781,-1.42244],-269.036]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_GuardHouse_01_F":
				{
				_templates = [[["Land_OfficeCabinet_01_F",[-2.27686,-4.56543,-1.00598],-269.898],["Land_TableDesk_F",[-2.13184,-2.45313,-1.00598],-88.4501],["Land_TableDesk_F",[-0.00292969,-4.55957,-1.00598],0.826236],["Land_OfficeChair_01_F",[-1.5332,-0.740234,-1.00598],-116.413],["Land_OfficeChair_01_F",[0.844238,-1.08984,-1.00598],-219.285],["Land_OfficeChair_01_F",[-0.0820313,-3.50684,-1.00598],-343.258]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_Barracks_01_grey_F":
				{_templates = [[["Land_PlasticCase_01_large_F",[14.1396,2.37695,0.566253],2.57306],["Land_Sleeping_bag_folded_F",[13.1426,3.86133,0.566253],28.3914],["Land_Metal_rack_Tall_F",[12.1328,1.48096,0.566253],181.716],["OfficeTable_01_old_F",[10.0918,-1.46875,0.566253],-5.54492],["Land_OfficeChair_01_F",[10.5244,-2.92969,0.566253],10.1174],["Land_TableDesk_F",[13.5361,-4.01025,0.566253],0.194275],["Land_TableDesk_F",[2.55664,2.83203,0.566253],267.674],["Land_ChairPlastic_F",[4.00098,2.71094,0.566253],238.062],["Land_OfficeCabinet_01_F",[8.01758,4.13379,0.566253],270.076],["Land_OfficeCabinet_01_F",[7.74609,-4.13037,0.566253],181.687],["Land_OfficeChair_01_F",[4.47656,-3.59814,0.566253],69.8496],["Land_OfficeChair_01_F",[6.21094,-3.42041,0.566253],101.107],["Land_WoodenTable_small_F",[6.90625,-2.19238,0.566253],-2.83917],["Land_WoodenTable_small_F",[-5.43359,2.65625,0.566253],89.8059],["Land_CampingChair_V2_F",[-5.43359,3.69189,0.566253],14.806],["Land_CampingChair_V2_F",[-3.68359,3.02295,0.566253],270.092],["Land_CampingChair_V2_F",[-5.31152,1.66504,0.566253],180.092],["Fridge_01_closed_F",[1.04883,3.96191,0.566253],276.423],["Land_Metal_rack_Tall_F",[-2.27539,1.53711,0.566253],181.603],["Land_Metal_rack_Tall_F",[-12.6836,3.94092,0.566253],79.5004],["Land_Metal_rack_Tall_F",[-13.3008,2.00195,0.566253],96.2514],["Land_ShelvesMetal_F",[-9.37109,3.91162,0.566253],89.8557],["Land_CratesShabby_F",[-7.91797,-1.64355,0.566253],-1.69263],["Land_CratesShabby_F",[-7.6123,-2.94775,0.566253],88.3074],["Land_CratesShabby_F",[-7.72559,-4.04785,0.566253],88.4689],["Land_BarrelWater_F",[-12.8037,-3.69629,0.566253],286.315],["Land_BarrelWater_F",[-12.8506,-2.76904,0.566253],259.459],["Land_BarrelWater_F",[-12.7031,-1.95361,0.566253],259.459],["Land_ChairWood_F",[-3.59668,-4.47559,3.87029],30.2855],["Land_ChairWood_F",[-5.30469,-4.16016,3.87028],-21.2055],["Land_ShelvesWooden_F",[-7.8457,-2.65625,3.87107],175.843],["Land_Sleeping_bag_blue_F",[-9.25195,-3.02051,3.87107],155.795],["Land_Sleeping_bag_blue_folded_F",[-12.7354,-2.44189,3.87107],-11.4088],["Land_Sleeping_bag_folded_F",[-12.6484,-3.53613,3.87107],20.4237],["Land_Ground_sheet_folded_F",[-12.8057,-3.1084,3.87107],20.4237],["Land_LuggageHeap_01_F",[-8.24512,-3.90723,3.87107],227.432],["Land_LuggageHeap_02_F",[-12.3672,2.13721,3.87107],80.9485],["Land_BottlePlastic_V2_F",[-12.1328,3.30273,3.87107],46.3791],["Land_BottlePlastic_V2_F",[-12.2695,2.99365,3.87107],56.0586],["Land_FMradio_F",[-11.9551,3.57324,3.87107],187.099],["Land_Ground_sheet_folded_blue_F",[0.939453,3.67676,3.87107],146.441],["Land_Ground_sheet_F",[-0.390625,4.05029,3.87107],272.62],["Land_Sleeping_bag_folded_F",[1.01367,4.25195,3.87107],209.855],["Land_Metal_rack_Tall_F",[-5.87109,2.68311,3.87107],91.8763],["Land_Metal_rack_Tall_F",[7.48828,-1.77441,3.87107],275.188],["Land_Metal_rack_Tall_F",[7.7334,-3.15918,3.87107],275.188],["Land_OfficeCabinet_01_F",[2.09766,-3.86426,3.87107],84.9336],["Land_OfficeCabinet_01_F",[2.20801,-2.62793,3.87107],84.9336],["Land_OfficeCabinet_01_F",[5.13867,-4.18018,3.87107],182.16],["Land_OfficeCabinet_01_F",[2.28418,2.90674,3.87107],91.6397],["Land_TableDesk_F",[3.81152,1.67285,3.87107],3.4325],["Land_OfficeChair_01_F",[7.7002,4.05859,3.87107],208.865],["Land_OfficeChair_01_F",[13.7344,3.68018,3.87107],196.257],["Land_OfficeChair_01_F",[13.6543,2.05615,3.87107],145.207],["OfficeTable_01_new_F",[12.0547,1.64893,3.87107],175.217],["OfficeTable_01_new_F",[9.27344,2.76123,3.87107],90.9937],["Land_Icebox_F",[9.23828,-2.76123,3.87107],91.8418],["Land_CampingTable_F",[12.3633,-3.86914,3.87107],184.702],["Land_GasTank_01_blue_F",[10.6504,-3.6499,3.87107],135.195],["Land_GasTank_01_blue_F",[14.2354,-3.99609,3.87107],225.833],["Land_CanisterPlastic_F",[9.96094,-1.40039,3.87107],78.9671],["Land_PlasticCase_01_small_F",[10.1924,-2.7832,3.87107],120.011],["Land_CampingChair_V1_F",[11.498,-3.18994,3.87107],59.9792],["Land_CampingChair_V1_F",[12.7686,-3.19824,3.87107],14.9792]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_School_01_F":
				{
				_templates = [[["Land_TableDesk_F",[8.02246,0.0634766,-1.24323],85.6087],["Land_OfficeChair_01_F",[6.32031,0.25293,-1.24827],-189.728],["Land_ChairPlastic_F",[13.4248,-0.392578,-1.2474],-172.069],["Land_ChairPlastic_F",[13.2373,2.23633,-1.25234],-158.296],["Land_ChairPlastic_F",[10.5254,3.76465,-1.25233],-140.533],["Land_ChairPlastic_F",[11.2363,2.31543,-1.25187],-98.5027],["Land_ChairPlastic_F",[0.831055,-2.52539,-1.24418],-262.466],["Land_ChairPlastic_F",[-0.798828,-2.25977,-1.2458],-247.466],["Land_ChairPlastic_F",[-2.97461,-2.19922,-1.25034],-252.319],["Land_TableDesk_F",[-2.35254,0.37793,-1.24661],86.4042],["Land_OfficeChair_01_F",[-3.52344,0.262695,-1.25138],-219.542],["OfficeTable_01_new_F",[-9.24707,1.51953,-1.25342],-89.8762],["OfficeTable_01_new_F",[-9.23926,-0.501953,-1.25001],-90.7625],["OfficeTable_01_new_F",[-12.4561,1.54102,-1.25342],-91.0319],["OfficeTable_01_new_F",[-12.458,-0.568359,-1.25342],-91.1843],["Land_CampingChair_V2_F",[-13.4111,-0.480469,-1.25342],-270.234],["Land_CampingChair_V2_F",[-10.2705,1.78906,-1.25342],-236.235],["Land_CampingChair_V2_F",[-10.1357,-0.556641,-1.25342],78.3527]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_Warehouse_03_F":
				{
				_templates = [[["Land_CanisterFuel_F",[-9.63574,-0.923828,-2.36032],-10.1525],["Land_CanisterFuel_F",[-9.69824,0.227539,-2.36032],-43.6402],["Land_CanisterFuel_F",[-9.95605,1.28809,-2.36066],-64.8455],["Land_CanisterPlastic_F",[-9.18262,2.39453,-2.3616],-64.8455],["Land_CanisterPlastic_F",[-9.63281,3.83887,-2.36251],-123.787],["Land_CanisterPlastic_F",[-10.3145,2.38867,-2.36251],-76.5574],["Land_PlasticCase_01_large_F",[1.82031,5.12402,-2.3637],-271.073],["Land_PlasticCase_01_large_F",[-0.753906,4.41504,-2.36271],-247.296],["Land_BarrelWater_F",[-0.105469,3.91699,-2.36344],59.483]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
			case "Land_FuelStation_01_shop_F":
				{
				_templates =[[["Land_TableDesk_F",[1.66089,-1.79199,-2.01157],-271.251],["Land_TableDesk_F",[-0.0561523,-4.26611,-2.01157],-1.30554],["Land_OfficeChair_01_F",[0.815186,-1.7373,-2.01157],-280.488],["Land_OfficeChair_01_F",[-0.323486,-3.09229,-2.01157],-332.793],["Land_OfficeCabinet_01_F",[-5.30908,-4.23926,-2.01157],-270.782],["Land_TablePlastic_01_F",[-1.5708,1.55518,-2.01158],-183.059],["Land_ChairPlastic_F",[0.366455,2.13818,-2.01157],-183.214],["Land_ChairPlastic_F",[-1.14429,2.78125,-2.01157],-122.271],["Land_ChairPlastic_F",[-2.40649,2.625,-2.01157],-122.271],["Land_ShelvesWooden_F",[-3.7085,4.646,-2.01157],-267.555],["Fridge_01_closed_F",[-5.13794,3.00684,-2.01157],-267.17]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_Shop_City_01_F":
				{
				_templates = [[["Land_CashDesk_F",[2.75879,2.78125,-4.96122],48.3944],["Land_OfficeChair_01_F",[2.05078,3.65527,-4.94825],-229.361],["Land_ShelvesMetal_F",[5.75879,1.72363,-4.96344],1.34766],["Land_ShelvesMetal_F",[3.00586,-0.259766,-4.96907],-272.178],["Land_Metal_rack_F",[6.72559,5.47363,-4.94542],-2.63683]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
			case "Land_Shop_City_02_F":
				{
				_templates = [[["Land_Metal_rack_F",[0.516602,-6.31055,-4.36143],89.531],["Land_Metal_rack_F",[7.80469,-5.55273,-4.36095],-89.5549],["Land_Icebox_F",[6.77148,-1.83984,-4.36108],0.197617],["Land_Icebox_F",[4.58105,-1.84863,-4.3615],0.197617],["Land_CashDesk_F",[2.55664,-2.2207,-4.36165],90.7803],["Land_ChairWood_F",[1.7793,-3.21582,-4.36164],74.6861],["Land_ShelvesMetal_F",[3.21191,-6.29688,-4.3611],-3.59962],["Land_ShelvesMetal_F",[-9.69238,-2.39844,-4.34926],-270.216],["Land_CratesShabby_F",[-9.15137,-6.04492,-4.34926],-345.232],["Land_Sacks_goods_F",[-2.34131,-6.03906,-4.3608],-348.557],["Land_Sacks_heap_F",[-1.46191,-7.57031,-4.36013],-38.4277],["Land_Sacks_heap_F",[1.82715,1.10254,-4.36266],-273.467],["Land_ShelvesMetal_F",[4.87646,1.36816,-4.36162],-272.688],["Land_GasTank_01_blue_F",[4.67529,-0.417969,-4.36185],-161.058]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_Hotel_02_F":
				{
				_templates =[[["Land_OfficeChair_01_F",[7.44043,-0.131348,-3.38684],-214.856],["Land_OfficeChair_01_F",[5.86523,0.0187988,-3.38684],-128.924],["Land_LuggageHeap_01_F",[-1.30566,14.6733,-3.38684],-158.902],["Land_LuggageHeap_02_F",[-2.04688,7.19946,-3.38684],15.7998],["Land_LuggageHeap_02_F",[-2.2959,-5.81836,-3.38684],99.4852],["Land_LuggageHeap_02_F",[-7.60156,3.4729,0.109365],-4.95287],["Land_LuggageHeap_01_F",[-7.85352,-0.414063,0.109364],85.9007],["Land_LuggageHeap_03_F",[3.59863,0.740234,0.109367],-135.265],["Land_LuggageHeap_01_F",[2.17871,3.6687,-3.38684],11.8903]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
				
			// ALTIS
			case "Land_i_House_Small_01_V1_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]],[["Land_WoodenBed_01_F",[-3.33789,-3.33105,-1.04119],-268.445],["Land_Sofa_01_F",[-4.03418,-0.21875,-1.04176],-91.7512],["Land_TableSmall_01_F",[-2.4248,-0.59082,-1.04108],-94.1435],["Land_TableBig_01_F",[0.700195,-3.08203,-1.04117],-268.995],["Land_Rug_01_F",[-0.891602,-0.794922,-1.04152],-183.316],["Land_ArmChair_01_F",[-2.00098,0.759766,-1.04204],-178.468],["Land_ChairPlastic_F",[-0.476563,-3.43555,-1.0412],45.5165],["Land_CampingChair_V2_F",[0.62793,-1.5166,-1.04113],-280.45],["Land_OfficeCabinet_01_F",[-1.37793,-4.11816,-1.04108],-180.156],["Land_LuggageHeap_01_F",[-1.26953,-2.66016,-1.04105],-186.966],["Land_Rug_01_F",[3.18262,-2.44434,-1.04082],-180.624],["Land_Rug_01_Traditional_F",[-1.46289,3.16992,-1.0418],-267.918],["Land_WoodenTable_small_F",[3.83398,3.95898,-1.0416],-2.26194],["Land_Sacks_goods_F",[3.78516,2.24316,-1.04145],-54.406],["Land_CratesShabby_F",[-4.05859,2.19922,-1.04194],-254.39],["Land_Sack_F",[-4.0752,3.44141,-1.04205],-254.39],["Land_Sack_F",[-0.296875,4.37695,-1.04205],-47.8365],["Land_BarrelWater_F",[1.24609,2.17871,-1.04182],-92.1904],["Land_PlasticCase_01_large_F",[0.243164,2.15723,-1.04182],-92.1904],["Fridge_01_closed_F",[-0.701172,1.18945,-1.04115],-1.45707]]	];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
		
			case "Land_i_House_Small_01_V2_F":
				{
				_templates = [[["Land_WoodenCounter_01_F",[-3.94727,-0.629395,-1.04163],-88.6504],["Land_TableDesk_F",[-1.0791,-3.8916,-1.04021],-0.807007],["Land_OfficeChair_01_F",[-1.05762,-2.85791,-1.04028],-0.807007],["Land_OfficeCabinet_01_F",[1.14355,-2.00879,-1.04108],268.761],["Land_ChairWood_F",[-3.81641,2.36621,-1.04156],118.562],["Land_ChairWood_F",[-1.44238,2.45801,-1.04136],188.964],["Land_CanisterPlastic_F",[4.05176,4.40332,-1.04253],-55.2585],["Land_CanisterPlastic_F",[3.48438,4.48047,-1.04271],-0.525421],["Land_CanisterFuel_F",[2.29492,4.27539,-1.04265],-0.525421],["Land_CanisterFuel_F",[3.02734,4.26514,-1.04264],-30.5254],["Land_PlasticCase_01_large_F",[2.23242,1.74854,-1.04189],178.524],["Land_Sack_F",[-3.99805,-3.52539,-1.04111],-48.8213],["Land_Sack_F",[-3.72363,-2.43848,-1.04109],236.179],["Fridge_01_closed_F",[1.11035,-1.12256,-1.04033],-87.9361],["Land_CampingChair_V2_F",[-2.62305,0.669922,-1.0419],111.699],["Land_CampingChair_V2_F",[-2.8252,-0.407227,-1.04189],216.699],["Land_Metal_rack_Tall_F",[-0.736328,4.28418,-1.04265],0.549286]],[["Land_Rug_01_F",[-1.31445,-1.14209,-1.04063],-270.788],["Land_Rug_01_Traditional_F",[3.17285,-2.66211,-1.04078],-176.909],["Land_Rug_01_Traditional_F",[-2.31641,3.18945,-1.04189],-275.052],["Land_TableBig_01_F",[-1.54785,-1.104,-1.04065],0.50161],["Land_RattanChair_01_F",[-1.55762,-0.266602,-1.0409],0.50161],["Land_RattanChair_01_F",[0.167969,-1.43066,-1.04031],-72.2455],["Land_RattanChair_01_F",[-1.91602,-2.16602,-1.04071],-26.3502],["Land_WoodenCounter_01_F",[-4.10645,0.255859,-1.04208],-270.909],["Land_Sofa_01_F",[0.96582,-3.14893,-1.04101],-270.468],["Land_ArmChair_01_F",[-3.75879,-3.43896,-1.042],-38.3048],["Land_ArmChair_01_F",[3.72559,4.21436,-1.04165],-196.282],["Land_TableSmall_01_F",[2.14941,1.44727,-1.04084],-177.537],["Land_WoodenTable_small_F",[-3.5459,2.39746,-1.04188],-88.7707],["Land_WoodenCounter_01_F",[-1.11816,2.25391,-1.04183],1.22932]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_i_House_Small_01_V3_F":
				{
				_templates = [[["Land_TablePlastic_01_F",[-2.52344,0.897461,-1.04125],175.246],["Land_ChairPlastic_F",[-1.15039,0.199219,-1.04091],144.503],["Land_ChairPlastic_F",[-2.3418,-0.149414,-1.04186],109.023],["Land_ChairPlastic_F",[-3.81641,0.560547,-1.04204],38.8209],["Land_WoodenCounter_01_F",[-4.10352,-2.83887,-1.04187],88.2375],["Land_OfficeCabinet_01_F",[1.26758,-1.85059,-1.0407],269.757],["Land_Metal_rack_F",[-1.22266,-4.13379,-1.04176],178.711],["Land_ShelvesMetal_F",[3.03516,4.24902,-1.04174],271.221],["Land_CratesShabby_F",[-3.98633,2.41309,-1.04206],53.4946],["Land_Sack_F",[-0.853516,2.50586,-1.04223],174.282],["Land_Sacks_goods_F",[-2.35156,2.59766,-1.04239],167.574],["Fridge_01_closed_F",[1.08594,-3.24316,-1.04097],265.582],["Land_BarrelWater_F",[4.18555,1.45508,-1.04093],-6.30811],["Land_PlasticCase_01_large_F",[3.92969,-0.375,-1.04038],-6.30811]],[["Land_Sofa_01_F",[-3.93579,-2.11914,-1.04152],-91.8609],["Land_WoodenBed_01_F",[-1.45776,0.266602,-1.04089],-1.42151],["Land_Rug_01_F",[-1.33447,-2.68457,-1.0404],0.722244],["Land_TableBig_01_F",[0.9104,-2.0166,-1.04116],-90.0578],["Land_TableSmall_01_F",[-3.32886,0.494141,-1.04175],61.2341],["Fridge_01_closed_F",[-1.40942,-3.82617,-1.04091],-179.231],["Land_LuggageHeap_01_F",[-3.6001,-0.386719,-1.04157],87.5945],["Land_Basket_F",[2.17334,4.30664,-1.04172],50.9738],["Land_Basket_F",[3.16577,4.26563,-1.0417],124.521],["Land_CratesShabby_F",[3.96899,3.95898,-1.04158],141.762],["Land_Metal_rack_F",[2.11475,-1.375,-1.04117],93.1432],["OfficeTable_01_old_F",[4.02539,-1.03906,-1.04119],-88.8568],["Land_ShelvesMetal_F",[-1.09277,3.88379,-1.04155],87.807],["Land_Rug_01_Traditional_F",[3.14917,-3.0459,-1.04067],-92.1002],["Land_Rug_01_Traditional_F",[0.52832,0.166992,-1.041],176.862]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
			 
			case "Land_i_House_Small_02_V1_F":
				{
				_templates = [[["Land_RattanChair_01_F",[6.42578,1.75977,-0.703516],-40.6828],["Land_RattanChair_01_F",[6.61719,-0.146484,-0.704597],-97.9207],["Land_WoodenTable_large_F",[5.45898,0.337891,-0.706083],7.07932],["Land_ChairPlastic_F",[5.92578,-1.48438,-0.705217],42.2576],["Land_TableDesk_F",[1.62305,-1.47656,-0.703932],-97.0282],["Land_Metal_rack_F",[2.97266,-3.06641,-0.70537],-179.503],["Land_ShelvesWooden_F",[-0.0429688,2.57129,-0.705944],-92.9552],["Fridge_01_closed_F",[-2.51563,2.50586,-0.699205],-0.87532],["Land_Metal_rack_Tall_F",[-0.542969,-3.0918,-0.713911],-181.833],["Land_Basket_F",[0.226563,-0.222656,-0.711535],-131.186],["Land_Basket_F",[0.203125,-1.21582,-0.711565],-71.186],["Land_Sack_F",[0.359375,-2.125,-0.71229],-89.8174],["Land_BarrelWater_F",[-3.10547,0.206055,-0.710192],-0.944931]],[["Land_Rug_01_Traditional_F",[3.94922,-0.665039,-0.700873],-276.226],["Land_TableBig_01_F",[7.04395,-0.365234,-0.699853],-272.753],["Land_Sofa_01_F",[4.52051,2.33594,-0.699213],-180.689],["Land_ArmChair_01_F",[5.12012,0.525391,-0.704233],47.0609],["Land_WoodenBed_01_F",[2.27051,-1.7207,-0.707748],-273.019],["Land_ChairWood_F",[5.94824,-0.798828,-0.703342],-198.365],["Land_ChairWood_F",[6.90137,-1.90137,-0.701333],-178.016],["Land_TableDesk_F",[-0.201172,-2.90039,-0.711514],0.870331],["Land_OfficeChair_01_F",[-0.369141,-2.07129,-0.711163],0.870331],["Land_OfficeCabinet_01_F",[-2.31934,-2.62988,-0.71307],-179.13],["Land_Rug_01_Traditional_F",[-1.55273,-0.129883,-0.709927],-83.1452],["Land_LuggageHeap_03_F",[-2.4834,1.77246,-0.703915],60.3844],["Land_LuggageHeap_02_F",[-1.07813,2.23926,-0.702318],60.3844]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_i_House_Small_02_V2_F":
				{
				_templates = [[["Land_PlasticCase_01_large_F",[6.0708,2.58203,-0.701662],92.9396],["Land_BarrelWater_F",[7.09326,2.21875,-0.70167],83.0936],["Land_Sacks_heap_F",[7.11572,0.486328,-0.701641],83.0936],["Land_Sacks_goods_F",[6.79785,-1.58203,-0.701864],96.8073],["Land_CanisterPlastic_F",[1.41162,-3.12891,-0.704269],-27.081],["Land_CanisterPlastic_F",[1.77051,-2.03125,-0.703808],17.9189],["Land_CanisterFuel_F",[2.50732,-2.69922,-0.702868],48.3204],["Land_Suitcase_F",[3.59961,-2.79492,-0.70146],123.32],["Land_CampingTable_small_F",[1.89111,-0.714844,-0.703241],88.4045],["Land_CampingChair_V2_F",[2.6167,-1.76953,-0.702749],55.9598],["Land_ChairPlastic_F",[3.04785,-0.546875,-0.701822],103.461],["Land_ShelvesMetal_F",[-0.654297,-2.89844,-0.711678],-92.2556],["Land_Metal_rack_F",[0.423828,-0.792969,-0.710293],-89.5467],["Fridge_01_closed_F",[-3.17139,0.222656,-0.707691],89.3282],["Land_LuggageHeap_02_F",[-3.02344,2.27344,-0.706264],34.2025],["Land_Sack_F",[-0.199219,2.39844,-0.706984],-6.20187],["Land_ChairWood_F",[-2.74365,-0.472656,-0.709225],95.4369]],[["Land_WoodenBed_01_F",[6.37622,1.8877,-0.702529],-89.8121],["Land_WoodenBed_01_F",[6.31836,-0.961914,-0.702603],-89.7693],["Land_Sofa_01_F",[2.37769,-2.73535,-0.705231],0.928199],["Land_TableSmall_01_F",[2.35303,-1.26172,-0.705261],0.928199],["Land_ArmChair_01_F",[1.88184,-0.107422,-0.703355],-106.204],["Land_Rug_01_Traditional_F",[3.43896,0.458008,-0.701894],-0.826742],["Land_LuggageHeap_03_F",[4.15259,0.412109,-0.704088],-252.271],["Fridge_01_closed_F",[0.280762,-0.172852,-0.705319],-92.0599],["Land_ShelvesWooden_F",[0.332764,-1.50488,-0.710074],0.668056],["Land_Sack_F",[0.207764,-2.8623,-0.710236],0.668056],["Land_Basket_F",[-3.06665,2.11035,-0.707057],-209.503],["Land_Basket_F",[-2.34131,2.36719,-0.707058],-291.674],["Land_BarrelWater_F",[0.220947,2.40039,-0.705207],-342.54],["Land_BarrelWater_F",[-0.558838,2.44238,-0.706317],-323.137],["Land_PlasticCase_01_large_F",[-1.15454,-3.01563,-0.711004],-90.6617],["Land_Rug_01_F",[-1.98657,-0.439453,-0.703908],-90.6617]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
	
			case "Land_i_House_Small_02_V3_F":
				{
				_templates =  [[["Land_RattanChair_01_F",[-3.01172,2.03223,-0.707756],22.4005],["Land_RattanChair_01_F",[-1.91211,2.00195,-0.708279],9.44495],["Land_WoodenTable_small_F",[-3.03906,-0.266602,-0.711452],181.163],["Land_ChairWood_F",[-0.34375,-2.41797,-0.710602],212.497],["Land_TableDesk_F",[0.230469,-0.685547,-0.705902],270.367],["Land_WoodenCounter_01_F",[6.96484,-0.484375,-0.701199],273.363],["Land_ShelvesWooden_F",[1.375,-1.1123,-0.704674],180.593],["Fridge_01_closed_F",[7.10352,1.27393,-0.699352],272.033],["Land_Microwave_01_F",[7.2207,-2.125,-0.700901],274.273],["Land_Basket_F",[6.79297,-2.84326,-0.702038],304.924],["Land_Basket_F",[5.81641,-2.78564,-0.7033],-10.0759],["Land_CratesShabby_F",[3.10156,-2.71191,-0.704041],265.261],["Land_Sacks_goods_F",[1.80664,-2.50195,-0.705379],257.841],["Land_BarrelWater_F",[7.12891,2.44092,-0.701103],37.9677],["Land_Sacks_heap_F",[3.27539,-0.260254,-0.706429],338.064]],[["Land_Rug_01_F",[3.99854,-0.720703,-0.705364],-1.11691],["Land_TableBig_01_F",[3.99707,-0.751953,-0.704931],-89.9432],["Land_Sofa_01_F",[6.91846,-0.511719,-0.701836],89.6371],["Land_ArmChair_01_F",[5.83594,-2.75195,-0.701483],1.85733],["Land_ArmChair_01_F",[6.14404,1.56836,-0.701246],144.432],["Land_TableSmall_01_F",[1.6084,-2.63086,-0.706055],-17.8039],["Land_Metal_rack_Tall_F",[1.46387,-0.378906,-0.703083],89.5106],["Land_WoodenBed_01_F",[-0.864746,-2.13281,-0.711863],179.786],["Land_Microwave_01_F",[-3.1875,2.24219,-0.707399],27.3004],["Land_FMradio_F",[-2.22119,2.45898,-0.706652],27.3004],["Land_CanisterPlastic_F",[-1.53223,2.48828,-0.706652],7.44592],["Land_CanisterPlastic_F",[-2.63232,1.85156,-0.708641],75.3384],["Land_PlasticCase_01_small_F",[0.434082,0.183594,-0.710058],-6.05789],["Land_BarrelWater_F",[-3.23145,0.162109,-0.710052],126.737],["Fridge_01_closed_F",[3.48291,2.48047,-0.704437],0.0520477],["Land_Rug_01_F",[-1.42334,0.197266,-0.710812],-1.0997]]	];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Small_03_V1_F":
				{
				_templates =  [[["Land_WoodenCounter_01_F",[2.42383,-3.29297,0.00672913],268.216],["Land_LuggageHeap_02_F",[2.71875,-5.5498,0.00656128],264.002],["Land_Basket_F",[4.93164,-5.55176,0.00733948],285.582],["Land_Basket_F",[4.92383,-4.46973,0.00733948],-29.4184],["Land_CratesShabby_F",[4.91602,-3.2334,0.00733948],15.5816],["Land_ShelvesWooden_F",[5.11719,1.33594,0.00758362],179.364],["Land_WoodenTable_large_F",[-4.69141,0.995117,0.00389862],-1.52823],["Land_RattanChair_01_F",[-4.76758,2.58691,0.00377655],-6.65387],["Land_RattanChair_01_F",[-3.74805,1.44922,0.0042572],267.956],["Land_RattanChair_01_F",[-4.67773,-0.50293,0.00337982],221.346],["Land_OfficeCabinet_01_F",[-1.8418,-2.10938,0.0055542],179.052],["Land_TableDesk_F",[-4.42773,4.35645,0.0038147],-1.80762],["Fridge_01_closed_F",[-1.58789,4.31348,0.00712585],269.185],["Land_Sack_F",[4.87305,-1.90234,0.0076828],250.357],["Land_BarrelWater_F",[4.94727,-1.01172,0.0076828],250.357],["Land_BarrelWater_F",[2.33789,4.31152,0.00382233],-2.01752],["Land_PlasticCase_01_large_F",[0.537109,4.32813,0.00534821],88.8865],["Land_CanisterPlastic_F",[1.17969,1.09375,0.00809479],0.828156],["Land_GasTank_01_blue_F",[0.603516,1.07617,0.00797272],-32.615],["Land_GasTank_01_blue_F",[-0.0332031,1.05176,0.00758362],309.013],["Land_Sleeping_bag_blue_F",[0.248047,2.80664,0.00714111],43.8263]],[["Land_Rug_01_F",[-3.29639,1.97363,0.00575066],0.152863],["Land_Rug_01_Traditional_F",[0.0854492,-0.775391,0.00575066],268.394],["Land_Rug_01_Traditional_F",[-3.53027,-0.853516,0.00575066],271.456],["Land_Rug_01_Traditional_F",[0.486084,3.36426,0.00575066],2.58652],["Land_LuggageHeap_02_F",[1.17847,4.22559,0.00575066],324.515],["Land_ArmChair_01_F",[1.18115,1.68164,0.00575066],357.092],["Land_ArmChair_01_F",[0.00512695,1.47949,0.00575066],322.384],["Land_WoodenBed_01_F",[-4.45215,3.56836,0.00575066],0.718964],["Land_Sofa_01_F",[-4.70044,0.539063,0.00575066],262.781],["Land_TableSmall_01_F",[-3.0874,0.44043,0.00575066],233.928],["Land_TableBig_01_F",[3.94897,-5.35254,0.00575066],1.64752],["Land_Rug_01_Traditional_F",[4.14307,-2.49121,0.00575066],7.46091],["Land_RattanChair_01_F",[3.60864,-4.50684,0.00575066],16.4688],["Land_RattanChair_01_F",[4.55835,-4.45508,0.00575066],61.4688],["Land_WoodenCounter_01_F",[4.84839,-2.3623,0.00575066],90.4353],["Land_Metal_rack_Tall_F",[2.49854,-1.6377,0.00575066],88.5497]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_01_V1_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_V1_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_V1_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_V1_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]],[["Land_Rug_01_F",[-0.461914,-5.62109,-2.56625],-268.063],["Land_Rug_01_F",[1.08789,-3.04004,-2.5636],-89.9305],["Land_Rug_01_Traditional_F",[2.76074,5.3623,-2.56409],-176.937],["Land_Rug_01_Traditional_F",[-2.33984,5.47461,-2.5642],-181.468],["Land_Rug_01_Traditional_F",[2.0918,-5.26758,0.855837],-180.023],["Land_Rug_01_Traditional_F",[1.16211,-1.02051,0.855974],-173.996],["Land_Rug_01_Traditional_F",[1.93262,5.17285,0.855873],-178.426],["Land_Rug_01_Traditional_F",[-2.59668,5.5166,0.853921],17.6522],["Land_TableBig_01_F",[2.82031,-6.28711,-2.56418],-180.751],["Land_TableBig_01_F",[-2.62793,5.36816,-2.56591],-275.811],["Land_ChairWood_F",[-3.31641,6.46387,-2.56568],-286.266],["Land_ChairWood_F",[-3.24414,4.15039,-2.56641],-242.939],["Land_RattanChair_01_F",[3.75781,-5.01367,-2.56458],-61.6959],["Land_RattanChair_01_F",[0.956055,-6.5459,-2.56639],-145.814],["Land_Sofa_01_F",[1.75635,-0.37207,-2.56343],-182.669],["Land_Sofa_01_F",[0.634277,-2.25195,-2.56494],-90.0689],["Land_TableSmall_01_F",[1.86719,-2.00293,-2.5641],-302.697],["Land_OfficeCabinet_01_F",[4.36914,-3.3916,-2.56503],-93.6923],["Fridge_01_closed_F",[-3.56348,1.92969,-2.56573],-239.156],["Land_ShelvesWooden_F",[-2.24414,1.51172,-2.56573],-269.156],["Land_ShelvesWooden_F",[1.56445,3.87402,-2.56622],-86.2943],["Land_CratesShabby_F",[3.21289,4.0498,-2.56622],-86.2943],["Land_Basket_F",[0.588867,6.3418,-2.56589],-202.056],["Land_WoodenBed_01_F",[2.29785,-4.44531,0.855435],-1.14327],["Land_WoodenBed_01_F",[1.31152,4.38965,0.855433],-181.239],["Land_ArmChair_01_F",[-1.62646,-1.14844,0.856492],-82.5575],["Land_ArmChair_01_F",[1.85352,-1.92285,0.855711],-245.334],["Land_ArmChair_01_F",[1.85352,-1.92285,0.855711],-245.334],["Land_ArmChair_01_F",[1.34277,0.235352,0.856608],-178.038],["Land_Rug_01_Traditional_F",[-2.61133,-4.33691,0.854292],-300.015],["Land_WoodenCounter_01_F",[-2.6416,-6.63281,0.853975],-179.863],["OfficeTable_01_new_F",[-3.81738,-2.1543,0.854006],-271.862],["Land_OfficeChair_01_F",[-3.86426,-3.59375,0.854006],-226.862],["Land_LuggageHeap_01_F",[0.266113,-5.95215,0.855242],-83.449],["Land_LuggageHeap_02_F",[-3.42969,6.45703,0.854727],-257.442]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_01_V2_F":
				{
				_templates =  [[["Land_GasTank_01_blue_F",[-3.97656,6.99414,-2.56544],-339.829],["Land_CanisterPlastic_F",[-3.84961,6.2832,-2.56587],-298.129],["Land_Basket_F",[-3.70801,3.83984,-2.56564],-237.191],["Land_Basket_F",[-2.70508,3.87695,-2.56539],-158.334],["Fridge_01_closed_F",[-2.49023,6.81348,-2.56538],1.14147],["Land_ShelvesMetal_F",[1.62988,6.62207,-2.56441],-88.5974],["Land_Metal_rack_F",[4.29883,4.12012,-2.56396],-90.1885],["Land_ChairWood_F",[3.5752,6.30859,-2.56417],-2.6498],["Land_WoodenTable_large_F",[1.15625,-3.80664,-2.56453],-91.2149],["Land_RattanChair_01_F",[2.77637,-3.62598,-2.5647],-101.663],["Land_RattanChair_01_F",[1.11816,-2.82715,-2.5647],-11.6628],["Land_OfficeCabinet_01_F",[1.03125,-6.8291,-2.56452],-180.518],["Land_ShelvesWooden_F",[-4.0332,1.73145,-2.5659],-180.466],["Land_LuggageHeap_02_F",[-2.6748,1.9707,-2.5659],-180.466],["Land_LuggageHeap_03_F",[-0.320313,-6.33008,0.854517],-134.863],["Land_PlasticCase_01_small_F",[1.9043,-3.76172,0.85601],-251.395],["Land_Pillow_old_F",[3.50391,-3.72852,0.855972],-244.07],["Land_Pillow_grey_F",[3.70313,-4.12793,0.855972],-289.07],["Land_Sleeping_bag_blue_F",[3.05176,-6.43652,0.855974],-92.3485],["Land_Sleeping_bag_blue_folded_F",[4.28125,-6.4668,0.855841],-108.329],["Land_CampingTable_F",[-3.80859,-5.6084,0.854322],-270.271],["Land_CampingChair_V1_F",[-2.85156,-6.06152,0.854322],-270.271],["Land_CampingChair_V1_F",[-1.74316,-6.62793,0.854843],-233.983],["Land_WoodenCounter_01_F",[2.01074,3.61426,0.856039],-0.116877],["Land_Metal_rack_Tall_F",[4.17676,4.43848,0.855709],-89.6306],["Land_Basket_F",[4.125,6.65625,0.855988],-6.62606],["Land_Basket_F",[3.87988,5.59668,0.856043],-28.2966],["Land_CratesShabby_F",[-3.71582,3.78516,0.854149],-185.246],["Land_Sacks_goods_F",[-3.18359,5.29297,0.854149],-185.246],["Land_Sack_F",[2.88965,-1.64941,0.856028],-35.4691],["Land_Sacks_heap_F",[1.42285,-0.176758,0.856005],-10.1893],["Land_Sacks_heap_F",[0.845703,-1.94824,0.856024],-171.842],["Land_BarrelWater_F",[-3.83496,2.29688,0.854204],-9.32506],["Land_BarrelWater_F",[-3.76367,-1.33594,0.854492],-286.741]],[["Land_TableBig_01_F",[1.69922,-3.97266,-2.5648],-95.0686],["Land_Rug_01_F",[0.720215,-0.955078,-2.56576],-225.379],["Land_Rug_01_F",[-0.0898438,4.83398,-2.56398],-2.44518],["Land_ChairPlastic_F",[0.664063,-4.11523,-2.56414],22.8664],["Land_CampingChair_V2_F",[3.06982,-4.49023,-2.56396],-14.6838],["Land_TableDesk_F",[4.05713,-6.16797,-2.56445],-268.515],["Land_OfficeCabinet_01_F",[0.753906,-6.77148,-2.56591],-187.026],["Land_OfficeChair_01_F",[2.83203,-6.06836,-2.56416],-50.9371],["Land_Basket_F",[-3.79395,1.58203,-2.56589],-206.448],["Land_CratesShabby_F",[-2.53613,1.98242,-2.56589],-206.448],["Land_Sofa_01_F",[-3.21289,3.7832,-2.56576],-0.524281],["Land_Sofa_01_F",[-3.01123,6.63867,-2.56575],-181.439],["Land_CampingTable_F",[1.87598,3.91797,-2.56583],-4.33334],["Land_CampingTable_small_F",[3.87207,4.01758,-2.56499],-301.342],["Land_LuggageHeap_02_F",[2.72656,-4.42383,0.855797],-234.763],["Land_LuggageHeap_01_F",[0.992188,-5.24023,0.854767],-300.672],["Land_LuggageHeap_03_F",[-3.2207,-5.79492,0.854237],18.9364],["Land_PlasticCase_01_large_F",[-1.12109,-6.23047,0.855206],-109.743],["Land_Suitcase_F",[3.6333,-6.3418,0.855789],-55.23],["Land_BarrelWater_F",[3.79395,-1.75391,0.855915],-42.6152],["Land_BarrelWater_F",[3.52441,-2.45703,0.855812],-53.4899],["Land_ArmChair_01_F",[1.29004,0.40625,0.85603],-273.112],["Land_Rug_01_F",[-0.271973,-0.96875,0.856026],-273.112],["Land_Rug_01_F",[-2.55273,-2.93555,0.855343],3.41399],["Land_Rug_01_F",[2.57422,5.5293,0.855434],9.08698],["Land_Rug_01_F",[-2.08447,5.45898,0.854095],-110.58],["Land_WoodenBed_01_F",[1.49854,4.51953,0.854111],-179.674]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};				

			case "Land_i_House_Big_01_V3_F":
				{
				_templates =  [[["Land_PlasticCase_01_large_F",[-3.8125,3.8291,-2.56395],-181.536],["Land_BarrelWater_F",[-3.76953,5.23145,-2.56395],-181.536],["Land_BarrelWater_F",[-3.88867,6.90137,-2.56383],-189.304],["Land_Sacks_heap_F",[-1.10156,6.55664,-2.56397],-180.161],["Land_Sacks_heap_F",[3.84766,3.97461,-2.56601],-6.99484],["Land_Sacks_goods_F",[0.599609,6.4248,-2.56445],64.4381],["Fridge_01_closed_F",[-3.49023,1.62207,-2.5642],86.9775],["Land_GasTank_01_blue_F",[-3.43164,2.39355,-2.56376],15.2075],["Land_ShelvesWooden_F",[1.53711,0.620117,-2.56392],-88.5952],["Land_ShelvesWooden_F",[-1.14844,-1.96973,-2.56396],-0.732254],["OfficeTable_01_old_F",[1.40234,-6.64063,-2.56627],-181.624],["Land_ChairWood_F",[1.78125,-5.625,-2.56628],-30.225],["Land_RattanChair_01_F",[4.17969,-3.00586,-2.56602],-112.441],["Land_RattanChair_01_F",[4.19336,-6.48633,-2.5663],-160.444],["Land_Metal_rack_Tall_F",[0.925781,6.84863,0.854462],3.26672],["Land_LuggageHeap_01_F",[3.97266,6.64258,0.854347],-2.1586],["Land_LuggageHeap_02_F",[-3.44531,4.17578,0.855583],-172.972],["Land_LuggageHeap_02_F",[-3.44531,4.17578,0.855583],-172.972],["Land_PlasticCase_01_small_F",[-0.207031,6.54395,0.85638],101.1],["Land_Sleeping_bag_F",[-2.20313,6.70313,0.856274],87.8726],["Land_Sleeping_bag_blue_F",[3.44531,3.78711,0.853817],-95.5269],["Land_Sleeping_bag_blue_folded_F",[4.08203,4.5625,0.853947],-85.0467],["Land_Sleeping_bag_folded_F",[-3.66797,6.54199,0.856266],88.2953],["Land_TablePlastic_01_F",[0.707031,-3.99805,0.853783],-174.027],["Land_ChairPlastic_F",[2.16797,-4.01367,0.855034],-107.125],["Land_ChairPlastic_F",[0.621094,-5.05176,0.85479],77.511],["Land_CratesShabby_F",[3.53906,-2.07129,0.85392],33.035],["Land_Sack_F",[1.09375,-2.10938,0.853767],19.419],["Land_Sacks_goods_F",[1.40625,0.0214844,0.854351],58.0305],["Land_CanisterPlastic_F",[1.24414,-1.20898,0.853928],33.5679],["Land_CanisterPlastic_F",[-0.0742188,-2.2959,0.853771],-21.6828],["Land_GasTank_01_blue_F",[-3.91406,-1.65039,0.854927],-85.2979],["Land_Suitcase_F",[-3.83984,-6.66309,0.854279],-56.4489]], [["Land_Rug_01_F",[2.86621,4.93823,-2.56564],0.523865],["Land_Rug_01_F",[-1.28223,5.33545,-2.56547],101.776],["Land_Rug_01_F",[0.834961,-0.859375,-2.56426],-89.4376],["Land_Rug_01_Traditional_F",[0.961914,-4.49878,-2.56425],-89.914],["Land_Sofa_01_F",[2.39551,-4.28784,-2.56557],85.1145],["Land_Sofa_01_F",[1.07813,-1.9834,-2.56591],174.411],["Land_TableSmall_01_F",[0.869141,-4.10889,-2.56442],57.818],["Land_CanisterPlastic_F",[-3.26563,1.81348,-2.56484],-84.7694],["Land_CanisterFuel_F",[-3.54297,2.2793,-2.56497],-47.4402],["Land_PlasticCase_01_small_F",[-2.16016,2.22021,-2.56497],-47.4402],["Land_Sacks_heap_F",[-2.21289,5.33472,-2.56535],-70.3793],["Land_Sacks_heap_F",[0.650391,4.43945,-2.56436],98.2543],["Land_RattanChair_01_F",[2.01172,-1.7002,0.855106],192.17],["Land_RattanChair_01_F",[2.23242,0.291992,0.854523],228.481],["Land_TableBig_01_F",[0.626953,-0.782471,0.854523],258.481],["Land_Metal_rack_Tall_F",[-0.121094,-3.45264,0.85503],1.52606],["Land_Metal_rack_Tall_F",[2.18945,-6.74146,0.855774],177.963],["OfficeTable_01_old_F",[4.25879,-4.90112,0.855068],269.416],["Land_OfficeChair_01_F",[3.17676,-4.88916,0.855064],-30.5841],["Land_OfficeCabinet_01_F",[2.40723,-3.65552,0.854584],-0.75238],["Fridge_01_closed_F",[-3.85059,-1.86304,0.854206],88.8173],["Land_ShelvesWooden_F",[-3.9043,-0.459717,0.854362],179.022],["Land_BarrelWater_F",[-3.37598,2.12842,0.854366],179.022],["Land_WoodenBed_01_F",[-3.19238,4.12427,0.855061],89.4925],["Land_Rug_01_F",[0.198242,5.10376,0.854843],76.4819],["Land_CampingChair_V1_F",[0.833984,6.62964,0.854248],33.0724],["Land_CampingChair_V2_F",[-3.77734,6.76929,0.854778],72.6743],["Land_LuggageHeap_03_F",[3.87695,3.88721,0.855343],253.225]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_02_V1_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]],[["Land_Rug_01_F",[0.00292969,3.44531,-2.62327],-87.2049],["Land_Rug_01_F",[-2.34082,-2.7041,-2.62327],-270.113],["Land_Rug_01_F",[-2.2998,-2.4668,0.784063],-262.735],["Land_Rug_01_F",[0.422852,2.07813,0.784063],-85.7117],["Land_TablePlastic_01_F",[-3.91113,-2.37207,-2.62327],-90.8103],["Land_WoodenTable_large_F",[1.14063,-1.60547,-2.62327],-90.5345],["Land_Sofa_01_F",[4.10254,2.50488,-2.62327],-271.501],["Land_Sofa_01_F",[2.18066,0.483398,-2.62327],0.880676],["Land_TableSmall_01_F",[1.91406,2.60156,-2.62327],-288.368],["Land_ArmChair_01_F",[2.02246,4.44629,-2.62327],-183.368],["Land_TableBig_01_F",[-3.05371,2.50684,-2.62327],-273.567],["Land_RattanChair_01_F",[-3.33496,0.499023,-2.62327],-248.815],["Land_RattanChair_01_F",[-3.63574,4.62793,-2.62327],55.6406],["Land_RattanChair_01_F",[-2.14648,2.27539,-2.62327],-85.3571],["Land_WoodenTable_large_F",[-3.80371,-2.46289,0.784063],1.00785],["Land_Metal_rack_Tall_F",[-3.67969,0.0126953,0.784063],-182.449],["Land_Metal_rack_Tall_F",[-4.31055,2.21875,0.784063],-269.027],["Land_Metal_rack_F",[-1.3584,5.02051,0.784063],1.24278],["Land_PlasticCase_01_large_F",[0.871094,0.142578,0.784063],-83.1418],["Land_LuggageHeap_03_F",[2.48535,0.489258,0.784063],-105.138],["Land_WoodenBed_01_F",[3.39746,2.69238,0.784063],-90.5565],["Land_TableSmall_01_F",[-3.39844,0.870117,0.784063],47.9833],["Land_Microwave_01_F",[-4.05273,1.42871,0.784063],-270.814],["Land_CanisterFuel_F",[-3.98828,3.09082,0.784063],-276.067],["Fridge_01_closed_F",[-3.85352,4.05957,0.784063],-291.067],["Fridge_01_closed_F",[-3.85352,4.05957,0.784063],-291.067]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 
			case "Land_i_House_Big_02_V2_F":
				{
				_templates = [[["Land_WoodenTable_small_F",[1.56738,-1.625,-2.62328],271.141],["Land_WoodenTable_large_F",[-3.33984,-1.33789,-2.62328],90.0771],["Land_CampingTable_F",[2.08398,0.425781,-2.62327],181.147],["Land_CampingChair_V2_F",[2.17773,1.20703,-2.62327],-22.5533],["Land_CampingChair_V2_F",[1.29492,1.27344,-2.62328],-43.1543],["Land_WoodenCounter_01_F",[4.19727,3.00977,-2.62327],89.469],["Land_TableDesk_F",[-3.73633,1.13477,-2.62328],269.018],["OfficeTable_01_new_F",[-3.78809,3.66797,-2.62328],89.018],["Land_OfficeChair_01_F",[-2.83887,0.837891,-2.62328],254.018],["Land_OfficeChair_01_F",[-3.08398,3.41797,-2.62328],254.018],["Land_OfficeCabinet_01_F",[-3.32227,-0.974609,0.784061],-2.43185],["Land_ChairWood_F",[-4.03516,-3.76172,0.784061],79.9433],["Land_WoodenTable_small_F",[-1.21094,-3.40234,0.784058],88.4992],["Land_ShelvesMetal_F",[4.31152,3.40234,0.784065],179.607],["Fridge_01_closed_F",[4.21387,1.67578,0.784065],267.967],["Land_CratesShabby_F",[4.24414,0.425781,0.784065],263.903],["Land_Sacks_goods_F",[-3.46875,1.21094,0.784061],114.213],["Land_CanisterFuel_F",[-3.3418,2.83984,0.784061],53.7771],["Land_CanisterPlastic_F",[-3.9541,4.7832,0.784061],17.3919],["Land_PlasticCase_01_large_F",[1.37695,0.195313,0.784065],267.892],["Land_Sleeping_bag_folded_F",[1.25684,4.35742,0.784061],1.91339],["Land_Sleeping_bag_folded_F",[1.90039,4.49805,0.784061],76.9134],["Land_Ground_sheet_folded_blue_F",[0.378906,4.64648,0.784061],121.854],["Land_Ground_sheet_folded_F",[1.07617,4.85938,0.784061],166.999]],[["Fridge_01_closed_F",[4.0498,0.137695,-2.62311],181.769],["Land_ShelvesWooden_F",[4.12842,2.01563,-2.6231],180.311],["Land_Metal_rack_Tall_F",[4.09814,3.71582,-2.62344],-90.5137],["Land_Sack_F",[4.32422,4.76465,-2.62396],-11.3237],["Land_Sacks_goods_F",[2.32617,0.682617,-2.62298],-130.434],["Land_BarrelWater_F",[-3.87891,0.112305,-2.62265],139.072],["Land_BarrelWater_F",[-3.77148,1.07422,-2.62268],134.951],["Land_PlasticCase_01_large_F",[-3.77734,2.76563,-2.62275],184.319],["Land_GasTank_01_blue_F",[2.03418,4.8252,-2.62394],29.6192],["Land_Rug_01_F",[0.275391,1.83691,-2.62278],-90.5803],["Land_Rug_01_F",[-3.21143,-2.34766,-2.62277],181.988],["Land_LuggageHeap_02_F",[1.43945,-1.57324,-2.62385],11.2137],["Land_LuggageHeap_01_F",[-3.38477,-1.38184,0.784335],158.436],["Land_CratesShabby_F",[-3.46191,-2.61426,0.784656],194.384],["Land_Basket_F",[0.631836,-3.58496,0.783702],-13.3869],["Land_WoodenBed_01_F",[2.09814,0.881836,0.784399],181.001],["Land_Sofa_01_F",[-3.771,1.98535,0.784729],-90.0663],["Land_TableSmall_01_F",[-1.86426,2.1875,0.784753],-75.7475],["Land_ArmChair_01_F",[-0.84375,2.70703,0.784401],75.793],["Land_TableBig_01_F",[3.39355,4.5,0.783393],181.111],["Land_CampingChair_V2_F",[3.57031,3.71777,0.783393],180.68]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_02_V3_F":
				{
				_templates = [[["Land_PlasticCase_01_large_F",[2.16797,-1.61328,-2.62327],4.28305],["Land_LuggageHeap_02_F",[1.16113,-1.52539,-2.62327],7.3073],["Land_Basket_F",[4.0415,0.283203,-2.62327],-43.5342],["Land_Basket_F",[2.98145,0.339844,-2.62327],-32.6877],["Land_CratesShabby_F",[2.09668,0.601563,-2.62327],-32.6877],["Land_Sack_F",[0.81543,0.669922,-2.62327],-32.6877],["Land_Sack_F",[-3.6875,0.335938,-2.62327],-118.477],["Land_Sacks_goods_F",[-3.61523,3.21289,-2.62327],153.458],["Land_ShelvesWooden_F",[4.26025,4.01953,-2.62327],-2.47742],["Land_ShelvesWooden_F",[-4.05713,-1.65625,-2.62327],177.668],["Fridge_01_closed_F",[2.19189,0.357422,0.784061],180.299],["Land_Metal_rack_Tall_F",[3.50244,0.240234,0.784061],184.706],["Land_Metal_rack_Tall_F",[4.46191,4.50195,0.784061],-88.365],["Land_Basket_F",[1.53516,4.4375,0.78406],-26.3235],["Land_Sacks_heap_F",[-3.37256,0.869141,0.784061],89.7987],["Land_BarrelWater_F",[-3.46045,2.41992,0.784061],80.7871],["Land_BarrelWater_F",[-3.62842,3.46094,0.784061],155.787],["Land_ChairWood_F",[4.03125,1.1875,0.784061],-95.0855],["Land_ChairWood_F",[3.9458,3.54297,0.784061],-87.795],["Land_OfficeCabinet_01_F",[-3.20947,-1.03125,0.784061],-1.02269],["Land_Sleeping_bag_folded_F",[-3.87842,-1.26758,0.784061],98.4081],["Land_Ground_sheet_folded_blue_F",[-4.07178,-2.48438,0.784061],98.4081]],[["Land_Rug_01_Traditional_F",[-0.0664063,3.01758,-2.62327],168.829],["Land_TableBig_01_F",[3.86963,1.21484,-2.62328],90.4853],["Land_TableBig_01_F",[-3.70361,3.92383,-2.62328],270.791],["Land_Sofa_01_F",[-3.17188,0.420898,-2.62327],-0.127716],["Land_Sofa_01_F",[1.00098,0.295898,-2.62327],-0.417755],["Land_CampingChair_V2_F",[2.83496,1.5498,-2.62328],122.629],["Land_RattanChair_01_F",[4.17773,3.03906,-2.62328],272.629],["Fridge_01_closed_F",[1.53223,-1.58105,-2.62327],275.384],["Land_ShelvesWooden_F",[-2.99561,-1.1377,-2.62327],90.1546],["Land_LuggageHeap_01_F",[4.2749,-1.36035,-0.825941],-7.98007],["Land_CratesShabby_F",[-3.94775,-1.18945,0.784061],89.9658],["Land_CratesShabby_F",[-3.67969,-2.44727,0.784061],179.966],["Land_Rug_01_Traditional_F",[1.89453,2.52539,0.784061],-0.717804],["Land_Rug_01_Traditional_F",[-1.28516,1.33984,0.78406],269.905],["Land_Rug_01_Traditional_F",[-2.71924,3.71973,0.78406],180.881],["Land_WoodenBed_01_F",[3.6543,0.819336,0.78406],179.736],["Land_WoodenBed_01_F",[1.52539,0.887695,0.784061],179.882],["Land_WoodenTable_small_F",[1.729,4.33203,0.78406],271.408],["Land_WoodenCounter_01_F",[-4.04004,1.08789,0.784061],267.07],["Land_TableDesk_F",[-1.0625,4.59375,0.78406],181.504],["Land_OfficeChair_01_F",[-1.00098,3.64551,0.78406],181.504],["Land_OfficeCabinet_01_F",[-4.06445,3.39355,0.78406],90.9898]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
		
			case "Land_i_Shop_01_V1_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		


			case "Land_i_Shop_01_V2_F":
				{
				_templates =  [[["Fridge_01_closed_F",[3.08594,4.21289,-2.76229],-181.554],["Land_Icebox_F",[1.42578,-0.0380859,-2.76224],-90.5887],["Land_Icebox_F",[-2.77344,-1.99707,-2.76136],-1.16144],["Land_CashDesk_F",[-2.74219,3.81445,-2.76084],0.985016],["Land_CampingChair_V2_F",[-2.19922,4.92676,-2.76065],22.5552],["Land_Metal_rack_F",[-3.54297,0.237305,-2.76093],90.077],["Land_Metal_rack_F",[-3.54688,1.55664,-2.76093],90.077],["Land_Metal_rack_Tall_F",[-1.0625,6.21387,-2.76087],-2.05241],["Land_Metal_rack_Tall_F",[-3.41016,5.37988,1.11005],92.3272],["Land_TableDesk_F",[-3.14844,2.06934,1.1102],-90.9453],["Land_OfficeChair_01_F",[-2.01953,2.09473,1.10979],-90.9453],["Land_OfficeCabinet_01_F",[-3.44531,-1.08301,1.11004],91.1442],["Land_OfficeCabinet_01_F",[-3.48438,-0.046875,1.10991],91.3931],["Land_WoodenCounter_01_F",[1.38672,0.825195,1.10851],89.1256],["Land_ChairWood_F",[0.234375,-0.736328,1.10896],-137.889],["Land_ChairWood_F",[0.318359,0.873047,1.10843],97.9613]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};					
			
			case "Land_i_Shop_01_V3_F":
				{
				_templates =  [[["Land_CashDesk_F",[-2.51563,4.05078,-2.75946],-3.08531],["Land_Icebox_F",[-3.05566,0.322266,-2.76091],92.9996],["Land_ShelvesMetal_F",[0.887695,0.810547,-2.75928],94.3427],["Land_OfficeChair_01_F",[-3.1377,5.73413,-2.76177],-170.402],["Land_LuggageHeap_01_F",[3.18652,4.79297,-2.76347],-119.654],["Land_CratesShabby_F",[-3.02246,4.10352,1.11193],103.7],["Land_Sack_F",[-2.87305,2.44775,1.11145],-237.117],["Land_Sack_F",[-2.78223,0.779541,1.11123],-221.076],["Land_Sacks_heap_F",[1.03027,1.40894,1.10914],1.2091],["Land_Sacks_heap_F",[0.969727,-0.264404,1.10968],91.2091]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_Shop_02_V2_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_Stone_Shed_V3_F":
				{
				_templates =  [[["Land_CratesShabby_F",[-2.58691,0.46875,-0.101868],-276.332],["Land_CratesShabby_F",[-2.9707,3.1582,-0.101288],-323.032],["Land_Sacks_heap_F",[0.973633,3.09668,-0.0992355],-64.1389]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_Addon_02_V1_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[-2.63477,0.432861,0.112274],118.33],["Land_CanisterPlastic_F",[-2.64453,1.48047,0.112267],151.097],["Land_GasTank_01_blue_F",[-2.83203,2.32251,0.112267],137.304],["Land_GasTank_01_blue_F",[-2.60547,3.45093,0.112267],197.304],["Land_Sacks_goods_F",[2.63867,3.5769,0.112267],37.0699],["Land_Sacks_goods_F",[0.0976563,3.60352,0.112267],234.105],["Land_Sack_F",[0.322266,0.36084,0.112267],-3.7146]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_Hospital_side1_F":
				{
				_templates =  [[["Land_ChairPlastic_F",[9.42212,-19.2959,-7.89858],188.066],["Land_ChairPlastic_F",[9.04297,-15.5488,-7.89656],188.066],["Land_ChairPlastic_F",[4.56348,-13.6055,-7.89818],284.444],["Land_ChairPlastic_F",[1.71143,-13.3193,-7.89874],254.879],["Land_TableDesk_F",[4.10132,-11.7012,-7.89764],358.663],["Land_TableDesk_F",[-1.35913,-11.5898,-7.89979],358.425],["Land_TableDesk_F",[-5.66235,-8.60059,-7.90144],269.576],["Land_TableDesk_F",[-5.86011,-1.98242,-7.8973],270.471],["Land_TableDesk_F",[-1.4624,2.29688,-7.89318],178.873],["Land_TableDesk_F",[1.95679,-4.00195,-7.89482],0.476471],["Land_TableDesk_F",[1.97754,-5.08398,-7.89636],181.152],["Land_OfficeChair_01_F",[-4.32422,-8.56055,-7.89995],313.018],["Land_OfficeChair_01_F",[-1.21265,-10.2383,-7.89867],58.5525],["Land_OfficeChair_01_F",[4.05371,-10.1025,-7.89685],88.9229],["Land_OfficeChair_01_F",[2.17676,-6.82617,-7.89763],214.224],["Land_OfficeChair_01_F",[-4.2937,-2.12891,-7.89715],242.717],["Land_OfficeChair_01_F",[-1.40942,1.15234,-7.89421],223.927],["Land_OfficeCabinet_01_F",[7.79297,2.79004,-7.89371],357.304],["Land_OfficeCabinet_01_F",[9.58325,0.0595703,-7.89311],266.017],["Land_OfficeCabinet_01_F",[9.56909,-4.06836,-7.8938],269.959],["OfficeTable_01_new_F",[9.26563,-6.82129,-7.89424],269.959],["OfficeTable_01_old_F",[9.32349,-9.87891,-7.89488],269.959],["Land_OfficeChair_01_F",[8.59033,-8.10254,-7.89442],269.959]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_Hospital_main_F":
				{
				_templates =  [[["Land_OfficeChair_01_F",[11.8662,-0.567383,-8.01427],222.703],["Land_OfficeChair_01_F",[11.7969,-3.79395,-8.01486],274.093],["Land_OfficeChair_01_F",[11.4407,-8.85156,-8.01543],319.189],["Land_OfficeCabinet_01_F",[14.1477,-6.70703,-8.0136],265.536],["Land_OfficeCabinet_01_F",[12.4312,-12.6191,-8.01581],179.788],["Land_ChairPlastic_F",[6.1792,-20.7314,-8.01654],94.5191],["Land_ChairPlastic_F",[3.07446,-20.4092,-8.01648],109.751],["Land_ChairPlastic_F",[-0.787842,-20.3115,-8.01649],108.606],["Land_ChairPlastic_F",[-1.89111,-20.3066,-8.01653],99.6855],["Land_ChairPlastic_F",[-4.32666,-19.9893,-8.0165],107.424],["Land_ChairPlastic_F",[-3.1875,-15.2627,-8.01654],81.1865],["Land_ChairPlastic_F",[-1.81909,-15.0957,-8.01653],81.1865],["Land_ChairPlastic_F",[-0.109375,-15.2178,-8.01653],81.1865],["Land_ChairPlastic_F",[1.57642,-15.2334,-8.01654],81.1865],["Land_ChairPlastic_F",[2.07031,-16.7422,-8.01461],282.006],["Land_ChairPlastic_F",[-0.0100098,-16.6426,-8.01463],285.361],["Land_ChairPlastic_F",[-1.99756,-16.2695,-8.01462],256.266],["Land_ChairPlastic_F",[-3.42603,-16.9844,-8.01462],256.266],["Land_ChairPlastic_F",[13.9829,8.11816,-8.01143],188.066],["Land_ChairPlastic_F",[14.0769,10.2412,-8.01076],188.066],["Land_ChairPlastic_F",[8.24146,9.00488,-8.01239],172.315],["Land_ChairPlastic_F",[8.09619,10.5889,-8.01216],172.315],["Land_ChairPlastic_F",[8.20923,11.9453,-8.0126],103.496],["Land_ChairPlastic_F",[9.56494,11.8906,-8.01273],0.41571],["Land_ChairPlastic_F",[9.24878,10.4707,-8.01311],21.2025],["Land_ChairPlastic_F",[9.7793,8.59961,-8.01328],14.2363],["Land_OfficeChair_01_F",[11.8389,0.361328,-8.01363],157.688]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_CarService_F":
				{
				_templates =  [[["Land_CashDesk_F",[3.88208,4.31836,-1.25606],-1.00175],["Land_CashDesk_F",[2.05688,4.36133,-1.25606],-1.56795],["Land_CampingChair_V2_F",[3.76758,5.55859,-1.25606],-118.775],["Land_CampingChair_V2_F",[1.88794,5.36035,-1.25606],-43.7752],["Land_Icebox_F",[4.27637,0.712891,-1.25606],-87.8782],["Land_ShelvesMetal_F",[0.783203,1.16211,-1.25606],1.65422],["Land_Metal_rack_Tall_F",[4.55444,2.36426,-1.25606],-91.1416],["Land_PlasticCase_01_small_F",[-4.2146,7.78027,-1.28121],90.8949],["Land_Suitcase_F",[-4.93677,6.48242,-1.34064],105.895],["Land_CanisterFuel_F",[-0.868164,7.85742,-1.30537],-0.733185]],[["Land_ToiletBox_F",[-0.798828,7.31836,-1.32612],0.968552],["Land_Bucket_painted_F",[-0.462891,5.04395,-1.278],-71.4945],["Land_Bucket_painted_F",[-0.608154,4.67285,-1.24443],-106.827],["Land_WoodenCrate_01_F",[-0.680664,3.60938,-1.33706],180.4],["Land_CratesShabby_F",[-0.635986,2.24707,-1.29713],-169.719],["Land_GarbageHeap_02_F",[-4.33325,0.924805,-1.22588],-91.2802],["Land_JunkPile_F",[-3.68066,6.94531,-1.27075],150.141],["Land_GarbageContainer_open_F",[-4.62915,4.7793,-1.37846],-90.1608],["Land_BarrelTrash_grey_F",[-1.77881,7.99512,-1.30081],172.032],["Land_BarrelTrash_grey_F",[-0.58252,-1.36426,-1.31081],13.9082],["Land_BarrelTrash_grey_F",[-1.08813,-1.625,-1.31081],65.0054],["Land_BarrelTrash_F",[-0.581543,-0.772461,-1.31081],11.4019],["Land_BarrelTrash_F",[-1.08911,-0.880859,-1.31081],92.8956],["Land_BarrelTrash_grey_F",[-0.84375,-0.214844,-1.33429],92.8956],["Land_Bench_F",[3.48486,-1.49902,-1.30274],89.7291],["Land_Bench_F",[4.6604,-0.145508,-1.30274],180.127],["Land_CampingTable_small_F",[3.05859,0.424805,-1.26256],180.69],["Land_TableDesk_F",[0.55835,4.63867,-1.31312],-89.651],["Land_CashDesk_F",[1.00659,3.35938,-1.25606],-0.0212708],["Land_OfficeChair_01_F",[1.36133,4.96289,-1.28048],-47.8687],["Land_Laptop_F",[0.598877,4.59863,-0.477567],-71.2],["Land_WaterCooler_01_new_F",[4.19897,8.28125,-1.28813],0.889847],["Land_GarbageBin_01_F",[0.657715,2.4834,-1.07014],51.5958],["Land_WoodenTable_large_F",[4.37793,2.99805,-1.28836],0.963593],["Land_WoodenBox_F",[4.36182,4.68066,-1.25606],-95.1816],["Land_MetalBarrel_F",[3.87524,5.82617,-1.27874],168.715],["Land_OfficeCabinet_01_F",[4.71704,6.91309,-1.28656],-89.9677],["Land_MetalBarrel_F",[4.56836,6.11426,-1.27874],-167.391],["Land_WoodenBox_F",[1.43311,7.91992,-1.25606],15.5185],["Land_Bucket_painted_F",[2.25732,8.05859,-0.844428],17.3957]],[["Land_ToolTrolley_02_F",[-2.38179,8.11719,-1.25895],100.507],["Land_FireExtinguisher_F",[-0.417236,5.28027,-1.27571],-93.779],["Land_Portable_generator_F",[-4.87378,-1.19531,-1.29026],117.014],["Land_ShelvesMetal_F",[3.96167,6.56836,-1.25896],-88.0102],["Land_ShelvesMetal_F",[3.97021,4.44238,-1.25896],-91.3878],["Land_ShelvesMetal_F",[3.96313,2.28418,-1.25896],-90.6151],["Land_ShelvesMetal_F",[3.97681,-0.105469,-1.25896],-90.5952],["Land_Icebox_F",[1.14746,8.05176,-1.32831],0.0249939],["Land_CashDesk_F",[0.947021,4.26953,-1.25606],0.30426],["Land_ChairWood_F",[1.47119,4.97461,-1.2554],-29.5835],["Land_Sacks_heap_F",[-0.883789,-0.820313,-1.39342],87.6564],["Land_CratesShabby_F",[-0.793701,7.8877,-1.3059],50.5728],["Fridge_01_closed_F",[-0.591309,0.416992,-1.34517],-89.5873],["Land_ShelvesWooden_F",[0.428223,1.4209,-1.30785],-0.325439],["Land_ShelvesWooden_F",[0.424072,0.461914,-1.30785],-0.0588226],["Land_Metal_rack_Tall_F",[-5.21143,1.6709,-1.28708],90.0396],["Land_Metal_rack_Tall_F",[-5.21851,2.42773,-1.28782],91.2058],["Land_Metal_rack_Tall_F",[-5.2251,3.19531,-1.28848],89.5169],["Land_Leaflet_03_F",[0.120361,5.06445,0.438939],87.9245],["Land_ToolTrolley_01_F",[-4.87061,4.38574,-1.28081],16.925],["Land_Bucket_clean_F",[-0.414551,4.47949,-1.29443],-71.43],["Land_WoodenCounter_01_F",[-0.675293,2.49414,-1.3137],-90.0238],["Land_CanisterFuel_F",[-5.11694,6.9668,-1.22956],29.9609]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_Offices_01_V1_F":
				{
				_templates =  [[["Fridge_01_closed_F",[12.4102,7.64551,-7.05996],-5.12289],["OfficeTable_01_old_F",[12.3311,5.58691,-7.05911],-90.1258],["OfficeTable_01_new_F",[9.46436,1.22266,-7.05802],182.067],["Land_OfficeChair_01_F",[9.61328,2.63672,-7.05802],182.067],["Land_OfficeChair_01_F",[11.332,5.65723,-7.05974],32.2299],["Land_OfficeCabinet_01_F",[8.37646,7.09961,-7.05887],89.6796],["Land_Metal_rack_Tall_F",[12.4795,2.72168,-7.05914],-88.3314]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
				
			case "Land_i_Garage_V1_F":
				{
				_templates = [[["Land_Metal_rack_F",[4.7627,-0.800781,-0.0950508],-91.2214],["Land_CratesShabby_F",[2.29297,-2.11328,-0.0996742],-171.421],["Land_CanisterFuel_F",[3.56641,2.48047,-0.0946388],-6.2593],["Land_CanisterPlastic_F",[4.41992,2.11523,-0.094635],-6.2593],["Land_GasTank_01_blue_F",[4.30371,-1.75781,-0.0975342],-134.613]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_Garage_V2_F":
				{
				_templates = [[["Land_Metal_rack_F",[4.7627,-0.800781,-0.0950508],-91.2214],["Land_CratesShabby_F",[2.29297,-2.11328,-0.0996742],-171.421],["Land_CanisterFuel_F",[3.56641,2.48047,-0.0946388],-6.2593],["Land_CanisterPlastic_F",[4.41992,2.11523,-0.094635],-6.2593],["Land_GasTank_01_blue_F",[4.30371,-1.75781,-0.0975342],-134.613]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			case "Land_House_Small_05_F":
				{
				_templates = [[["Land_TablePlastic_01_F",[-2.27759,4.47461,-1.08479],-0.0303669],["Land_ChairPlastic_F",[-2.06104,3.22852,-1.08459],-300.03],["Land_ChairPlastic_F",[-0.758789,4.20215,-1.08459],-205.387],["Land_Metal_rack_F",[1.06372,4.9,-1.0843],1.95515],["Fridge_01_closed_F",[-3.58472,-0.962402,-1.08638],-180.638],["Land_Basket_F",[-3.49634,2.08154,-1.08658],-235.633],["Land_Sack_F",[-3.47778,3.04053,-1.08616],-259.309],["Land_BarrelWater_F",[1.37671,2.81934,-1.08389],-28.8263],["Land_PlasticCase_01_small_F",[1.41821,0.745117,-1.08353],1.17369],["Land_CanisterFuel_F",[1.39722,-1.11133,-1.08453],-61.7261],["Land_GasTank_01_blue_F",[1.41504,-0.307617,-1.0839],-34.2241],["Land_WoodenTable_small_F",[-1.54272,-0.849121,-1.08609],-91.1185]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			// MALDEN
			case "Land_i_House_Small_02_c_blue_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-4.35205,1.75879,-0.588531],89.4604],["Land_RattanChair_01_F",[-4.56323,0.762695,-0.591324],113.514],["Land_ChairWood_F",[-2.03955,-3.35156,-0.590698],-96.5497],["Land_WoodenCounter_01_F",[-1.59277,-1.3916,-0.591003],90.9182],["OfficeTable_01_old_F",[-0.425537,-2.26367,-0.585556],85.8564],["Land_OfficeChair_01_F",[0.479248,-2.42969,-0.583649],-58.6722],["Land_OfficeCabinet_01_F",[4.42212,-3.48242,-0.582565],179.174],["Land_TableDesk_F",[5.18848,0.793945,-0.581619],89.4624],["Land_RattanChair_01_F",[4.26758,0.782227,-0.582291],119.297],["Land_PlasticCase_01_small_F",[-0.213379,-1.15918,-0.584213],-108.662],["Land_Suitcase_F",[3.31689,-3.47559,-0.583481],0.036087]], [["Land_Rug_01_F",[-2.82227,-2.03662,-0.592682],270.392],["Land_Rug_01_F",[-3.73438,0.789551,-0.591339],-1.31403],["Land_Rug_01_F",[2.46387,-1.46191,-0.583374],181.847],["Land_ChairWood_F",[8.46094,-3.02393,-0.509644],191.782],["Land_WoodenTable_large_F",[4.38965,1.29785,-0.579788],179.499],["Land_TableDesk_F",[0.327148,-2.98633,-0.584747],0.0712891],["Land_OfficeCabinet_01_F",[-0.50293,-0.881348,-0.584915],91.7174],["Land_OfficeChair_01_F",[0.639648,-1.89063,-0.584976],135.11],["Land_Metal_rack_Tall_F",[3.89258,-3.26953,-0.582748],180.521],["Fridge_01_closed_F",[-1.57813,-3.29395,-0.589783],179.831],["Land_Basket_F",[-2.59961,-3.22461,-0.590363],162.454],["Land_Sack_F",[-3.70508,-3.00342,-0.590683],138.023],["Land_Sacks_goods_F",[-4.75488,1.74023,-0.587936],-4.60416],["Land_Sacks_heap_F",[-4.26855,-0.00488281,-0.589813],26.8088]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_i_House_Small_02_c_yellow_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-4.35205,1.75879,-0.588531],89.4604],["Land_RattanChair_01_F",[-4.56323,0.762695,-0.591324],113.514],["Land_ChairWood_F",[-2.03955,-3.35156,-0.590698],-96.5497],["Land_WoodenCounter_01_F",[-1.59277,-1.3916,-0.591003],90.9182],["OfficeTable_01_old_F",[-0.425537,-2.26367,-0.585556],85.8564],["Land_OfficeChair_01_F",[0.479248,-2.42969,-0.583649],-58.6722],["Land_OfficeCabinet_01_F",[4.42212,-3.48242,-0.582565],179.174],["Land_TableDesk_F",[5.18848,0.793945,-0.581619],89.4624],["Land_RattanChair_01_F",[4.26758,0.782227,-0.582291],119.297],["Land_PlasticCase_01_small_F",[-0.213379,-1.15918,-0.584213],-108.662],["Land_Suitcase_F",[3.31689,-3.47559,-0.583481],0.036087]],[["Land_Rug_01_F",[-2.82227,-2.03662,-0.592682],270.392],["Land_Rug_01_F",[-3.73438,0.789551,-0.591339],-1.31403],["Land_Rug_01_F",[2.46387,-1.46191,-0.583374],181.847],["Land_ChairWood_F",[8.46094,-3.02393,-0.509644],191.782],["Land_WoodenTable_large_F",[4.38965,1.29785,-0.579788],179.499],["Land_TableDesk_F",[0.327148,-2.98633,-0.584747],0.0712891],["Land_OfficeCabinet_01_F",[-0.50293,-0.881348,-0.584915],91.7174],["Land_OfficeChair_01_F",[0.639648,-1.89063,-0.584976],135.11],["Land_Metal_rack_Tall_F",[3.89258,-3.26953,-0.582748],180.521],["Fridge_01_closed_F",[-1.57813,-3.29395,-0.589783],179.831],["Land_Basket_F",[-2.59961,-3.22461,-0.590363],162.454],["Land_Sack_F",[-3.70508,-3.00342,-0.590683],138.023],["Land_Sacks_goods_F",[-4.75488,1.74023,-0.587936],-4.60416],["Land_Sacks_heap_F",[-4.26855,-0.00488281,-0.589813],26.8088]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_i_House_Small_02_c_pink_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-4.35205,1.75879,-0.588531],89.4604],["Land_RattanChair_01_F",[-4.56323,0.762695,-0.591324],113.514],["Land_ChairWood_F",[-2.03955,-3.35156,-0.590698],-96.5497],["Land_WoodenCounter_01_F",[-1.59277,-1.3916,-0.591003],90.9182],["OfficeTable_01_old_F",[-0.425537,-2.26367,-0.585556],85.8564],["Land_OfficeChair_01_F",[0.479248,-2.42969,-0.583649],-58.6722],["Land_OfficeCabinet_01_F",[4.42212,-3.48242,-0.582565],179.174],["Land_TableDesk_F",[5.18848,0.793945,-0.581619],89.4624],["Land_RattanChair_01_F",[4.26758,0.782227,-0.582291],119.297],["Land_PlasticCase_01_small_F",[-0.213379,-1.15918,-0.584213],-108.662],["Land_Suitcase_F",[3.31689,-3.47559,-0.583481],0.036087]], [["Land_Rug_01_F",[-2.82227,-2.03662,-0.592682],270.392],["Land_Rug_01_F",[-3.73438,0.789551,-0.591339],-1.31403],["Land_Rug_01_F",[2.46387,-1.46191,-0.583374],181.847],["Land_ChairWood_F",[8.46094,-3.02393,-0.509644],191.782],["Land_WoodenTable_large_F",[4.38965,1.29785,-0.579788],179.499],["Land_TableDesk_F",[0.327148,-2.98633,-0.584747],0.0712891],["Land_OfficeCabinet_01_F",[-0.50293,-0.881348,-0.584915],91.7174],["Land_OfficeChair_01_F",[0.639648,-1.89063,-0.584976],135.11],["Land_Metal_rack_Tall_F",[3.89258,-3.26953,-0.582748],180.521],["Fridge_01_closed_F",[-1.57813,-3.29395,-0.589783],179.831],["Land_Basket_F",[-2.59961,-3.22461,-0.590363],162.454],["Land_Sack_F",[-3.70508,-3.00342,-0.590683],138.023],["Land_Sacks_goods_F",[-4.75488,1.74023,-0.587936],-4.60416],["Land_Sacks_heap_F",[-4.26855,-0.00488281,-0.589813],26.8088]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_i_House_Small_02_c_brown_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-4.35205,1.75879,-0.588531],89.4604],["Land_RattanChair_01_F",[-4.56323,0.762695,-0.591324],113.514],["Land_ChairWood_F",[-2.03955,-3.35156,-0.590698],-96.5497],["Land_WoodenCounter_01_F",[-1.59277,-1.3916,-0.591003],90.9182],["OfficeTable_01_old_F",[-0.425537,-2.26367,-0.585556],85.8564],["Land_OfficeChair_01_F",[0.479248,-2.42969,-0.583649],-58.6722],["Land_OfficeCabinet_01_F",[4.42212,-3.48242,-0.582565],179.174],["Land_TableDesk_F",[5.18848,0.793945,-0.581619],89.4624],["Land_RattanChair_01_F",[4.26758,0.782227,-0.582291],119.297],["Land_PlasticCase_01_small_F",[-0.213379,-1.15918,-0.584213],-108.662],["Land_Suitcase_F",[3.31689,-3.47559,-0.583481],0.036087]], [["Land_Rug_01_F",[-2.82227,-2.03662,-0.592682],270.392],["Land_Rug_01_F",[-3.73438,0.789551,-0.591339],-1.31403],["Land_Rug_01_F",[2.46387,-1.46191,-0.583374],181.847],["Land_ChairWood_F",[8.46094,-3.02393,-0.509644],191.782],["Land_WoodenTable_large_F",[4.38965,1.29785,-0.579788],179.499],["Land_TableDesk_F",[0.327148,-2.98633,-0.584747],0.0712891],["Land_OfficeCabinet_01_F",[-0.50293,-0.881348,-0.584915],91.7174],["Land_OfficeChair_01_F",[0.639648,-1.89063,-0.584976],135.11],["Land_Metal_rack_Tall_F",[3.89258,-3.26953,-0.582748],180.521],["Fridge_01_closed_F",[-1.57813,-3.29395,-0.589783],179.831],["Land_Basket_F",[-2.59961,-3.22461,-0.590363],162.454],["Land_Sack_F",[-3.70508,-3.00342,-0.590683],138.023],["Land_Sacks_goods_F",[-4.75488,1.74023,-0.587936],-4.60416],["Land_Sacks_heap_F",[-4.26855,-0.00488281,-0.589813],26.8088]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_i_House_Small_02_c_whiteblue_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-4.35205,1.75879,-0.588531],89.4604],["Land_RattanChair_01_F",[-4.56323,0.762695,-0.591324],113.514],["Land_ChairWood_F",[-2.03955,-3.35156,-0.590698],-96.5497],["Land_WoodenCounter_01_F",[-1.59277,-1.3916,-0.591003],90.9182],["OfficeTable_01_old_F",[-0.425537,-2.26367,-0.585556],85.8564],["Land_OfficeChair_01_F",[0.479248,-2.42969,-0.583649],-58.6722],["Land_OfficeCabinet_01_F",[4.42212,-3.48242,-0.582565],179.174],["Land_TableDesk_F",[5.18848,0.793945,-0.581619],89.4624],["Land_RattanChair_01_F",[4.26758,0.782227,-0.582291],119.297],["Land_PlasticCase_01_small_F",[-0.213379,-1.15918,-0.584213],-108.662],["Land_Suitcase_F",[3.31689,-3.47559,-0.583481],0.036087]], [["Land_Rug_01_F",[-2.82227,-2.03662,-0.592682],270.392],["Land_Rug_01_F",[-3.73438,0.789551,-0.591339],-1.31403],["Land_Rug_01_F",[2.46387,-1.46191,-0.583374],181.847],["Land_ChairWood_F",[8.46094,-3.02393,-0.509644],191.782],["Land_WoodenTable_large_F",[4.38965,1.29785,-0.579788],179.499],["Land_TableDesk_F",[0.327148,-2.98633,-0.584747],0.0712891],["Land_OfficeCabinet_01_F",[-0.50293,-0.881348,-0.584915],91.7174],["Land_OfficeChair_01_F",[0.639648,-1.89063,-0.584976],135.11],["Land_Metal_rack_Tall_F",[3.89258,-3.26953,-0.582748],180.521],["Fridge_01_closed_F",[-1.57813,-3.29395,-0.589783],179.831],["Land_Basket_F",[-2.59961,-3.22461,-0.590363],162.454],["Land_Sack_F",[-3.70508,-3.00342,-0.590683],138.023],["Land_Sacks_goods_F",[-4.75488,1.74023,-0.587936],-4.60416],["Land_Sacks_heap_F",[-4.26855,-0.00488281,-0.589813],26.8088]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	
			case "Land_i_House_Small_02_c_white_F":
				{
				_templates = [[["Land_WoodenTable_large_F",[-4.35205,1.75879,-0.588531],89.4604],["Land_RattanChair_01_F",[-4.56323,0.762695,-0.591324],113.514],["Land_ChairWood_F",[-2.03955,-3.35156,-0.590698],-96.5497],["Land_WoodenCounter_01_F",[-1.59277,-1.3916,-0.591003],90.9182],["OfficeTable_01_old_F",[-0.425537,-2.26367,-0.585556],85.8564],["Land_OfficeChair_01_F",[0.479248,-2.42969,-0.583649],-58.6722],["Land_OfficeCabinet_01_F",[4.42212,-3.48242,-0.582565],179.174],["Land_TableDesk_F",[5.18848,0.793945,-0.581619],89.4624],["Land_RattanChair_01_F",[4.26758,0.782227,-0.582291],119.297],["Land_PlasticCase_01_small_F",[-0.213379,-1.15918,-0.584213],-108.662],["Land_Suitcase_F",[3.31689,-3.47559,-0.583481],0.036087]],[["Land_Rug_01_F",[-2.82227,-2.03662,-0.592682],270.392],["Land_Rug_01_F",[-3.73438,0.789551,-0.591339],-1.31403],["Land_Rug_01_F",[2.46387,-1.46191,-0.583374],181.847],["Land_ChairWood_F",[8.46094,-3.02393,-0.509644],191.782],["Land_WoodenTable_large_F",[4.38965,1.29785,-0.579788],179.499],["Land_TableDesk_F",[0.327148,-2.98633,-0.584747],0.0712891],["Land_OfficeCabinet_01_F",[-0.50293,-0.881348,-0.584915],91.7174],["Land_OfficeChair_01_F",[0.639648,-1.89063,-0.584976],135.11],["Land_Metal_rack_Tall_F",[3.89258,-3.26953,-0.582748],180.521],["Fridge_01_closed_F",[-1.57813,-3.29395,-0.589783],179.831],["Land_Basket_F",[-2.59961,-3.22461,-0.590363],162.454],["Land_Sack_F",[-3.70508,-3.00342,-0.590683],138.023],["Land_Sacks_goods_F",[-4.75488,1.74023,-0.587936],-4.60416],["Land_Sacks_heap_F",[-4.26855,-0.00488281,-0.589813],26.8088]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};					

			case "Land_i_House_Small_01_b_blue_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]],[["Land_WoodenBed_01_F",[-3.31885,-2.75,-1.04144],92.1606],["Land_WoodenBed_01_F",[-1.74463,0.309326,-1.04109],-0.375671],["Land_Rug_01_F",[-0.359375,-2.61646,-1.04054],94.3338],["Land_TableSmall_01_F",[-4.19873,0.849609,-1.04213],0.487488],["Land_Rug_01_F",[3.29199,1.08911,-1.04071],1.93732],["Land_Rug_01_F",[-2.40967,3.50293,-1.04218],89.6165],["Land_TableBig_01_F",[3.79004,3.36816,-1.04137],268.395],["Land_RattanChair_01_F",[3.70898,1.28931,-1.04076],193.395],["Land_RattanChair_01_F",[2.46338,4.14648,-1.04164],87.8041],["Land_WoodenCounter_01_F",[-2.53711,2.37134,-1.0417],180.924],["Fridge_01_closed_F",[-1.03857,2.48511,-1.04224],180.137],["Land_ShelvesWooden_F",[3.99463,-2.27393,-1.04071],183.013]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			

			case "Land_i_House_Small_02_b_blue_F":
				{
				_templates = [[["Land_CampingTable_F",[-4.52881,1.90137,-0.588028],3.24768],["Land_CampingChair_V2_F",[-4.48291,1.12305,-0.590683],168.248],["Land_CampingChair_V2_F",[-3.00928,1.77588,-0.588455],-131.752],["Land_WoodenTable_small_F",[-2.12305,-2.80664,-0.590919],87.1347],["Land_OfficeCabinet_01_F",[-1.4624,-0.292969,-0.590393],-90.5812],["Fridge_01_closed_F",[-5.25928,-0.675781,-0.588394],88.6826],["Land_LuggageHeap_01_F",[-1.61865,-1.7002,-0.587791],-161.539],["Land_ShelvesWooden_F",[0.768555,-3.10889,-0.585327],-92.9928],["Land_Basket_F",[-0.217773,-2.94922,-0.585205],-126.326],["Land_CratesShabby_F",[-0.103516,-1.70996,-0.584274],-153.962],["Land_Sack_F",[-0.279297,-0.504883,-0.584274],170.58],["Land_PlasticCase_01_large_F",[4.97168,2.19385,-0.580101],88.9096],["Land_BarrelWater_F",[2.10889,-3.2334,-0.582039],-131.095],["Land_Metal_rack_Tall_F",[1.45605,2.21289,-0.582809],-1.64015],["Land_ChairWood_F",[4.00488,-3.11963,-0.580872],125.577]], [["Land_ShelvesWooden_F",[5.03613,1.45264,-0.58046],-4.37973],["Land_Rug_01_Traditional_F",[2.81396,-0.6604,-0.580338],179.624],["Land_Sofa_01_F",[-0.207031,-1.39795,-0.585907],266.922],["Land_ArmChair_01_F",[1.73047,-2.91113,-0.585495],-0.120544],["Land_TableSmall_01_F",[0.808594,-1.00098,-0.584824],8.17535],["Land_ArmChair_01_F",[4.73779,-0.262207,-0.582794],94.8493],["Land_WoodenBed_01_F",[-2.36133,-2.36279,-0.589874],180.799],["Land_TableBig_01_F",[-4.30518,1.84863,-0.587311],-0.194885],["Land_Rug_01_Traditional_F",[-3.41357,0.0297852,-0.584366],88.2166],["Land_CampingChair_V2_F",[-3.96582,-2.79395,-0.590652],84.4604],["Land_LuggageHeap_01_F",[-4.74902,0.418701,-0.590652],-27.0646],["Land_PlasticCase_01_small_F",[-2.56836,2.16943,-0.585083],90.4173]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_i_House_Big_01_b_blue_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_b_blue_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_b_blue_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_b_blue_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]], [["Land_Rug_01_Traditional_F",[1.40527,-4.7912,-2.56494],188.636],["Land_TableBig_01_F",[-1.32227,4.79187,-2.56494],178.995],["Land_TableBig_01_F",[1.01953,4.82434,-2.56494],182.168],["Land_RattanChair_01_F",[2.04199,6.93036,-2.56494],-2.92365],["Land_Sofa_01_F",[1.22656,-6.21259,-2.56494],-3.03351],["Land_Sofa_01_F",[1.24805,-3.53192,-2.56494],173.303],["Land_ArmChair_01_F",[2.34082,-4.90015,-2.56494],84.6665],["Land_WoodenTable_small_F",[1.44531,0.654114,-2.56494],93.0321],["Land_WoodenTable_small_F",[-2.8418,2.09845,-2.56494],266.954],["OfficeTable_01_new_F",[4.16406,-4.82819,0.855063],266.599],["OfficeTable_01_new_F",[1.81348,-6.1449,0.855063],181.904],["Land_OfficeChair_01_F",[3.1582,-4.15515,0.855063],-44.6044],["Land_OfficeChair_01_F",[3.18262,-6.11945,0.855063],256.003],["Land_OfficeCabinet_01_F",[0.0380859,-3.40271,0.855063],-0.0846558],["Land_Metal_rack_Tall_F",[-2.98926,-6.47131,0.855063],175.774],["Land_Metal_rack_Tall_F",[-3.95898,-4.79645,0.855063],85.0273],["Fridge_01_closed_F",[-2.21094,-6.61212,0.855063],179.273],["Land_BarrelWater_F",[-1.55664,-6.50146,0.855063],209.273],["Land_PlasticCase_01_small_F",[-3.87207,-5.76953,0.855063],193.438],["Land_RattanChair_01_F",[0.498047,-2.09833,0.855063],-65.9356],["Land_TablePlastic_01_F",[1.13477,0.201355,0.855063],173.88],["Land_Rug_01_F",[1.33594,5.66254,0.855063],87.9827],["Land_Rug_01_F",[-1.49219,5.07458,0.855063],-4.49963],["Land_WoodenBed_01_F",[1.19141,4.50024,0.855063],178.575],["Land_TableBig_01_F",[-2.66211,6.78253,0.855063],-2.0705]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_02_b_blue_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]],[["Land_TableBig_01_F",[4.08276,2.22266,-2.62328],-92.8421],["Land_CampingTable_small_F",[1.41125,0.470703,-2.62326],179.523],["Land_Rug_01_Traditional_F",[0.601929,2.99072,-2.62326],87.6949],["Land_ChairWood_F",[2.95508,1.20898,-2.62328],179.734],["Land_ChairWood_F",[3.73169,3.87988,-2.62326],-92.1608],["Land_Sofa_01_F",[-3.60962,1.43262,-2.62328],-88.6062],["Land_Sofa_01_F",[-2.6637,4.42676,-2.62328],177.932],["Land_TableSmall_01_F",[-2.37988,2.91016,-2.62328],-98.9703],["Land_Metal_rack_Tall_F",[1.01038,-1.12012,-2.62326],2.47485],["Land_Rug_01_Traditional_F",[-2.67651,-2.23047,-2.62328],151.037],["Land_Rug_01_Traditional_F",[-2.14575,-2.67285,0.784058],174.806],["Land_ArmChair_01_F",[-3.91174,-3.4707,0.784058],-86.0274],["Land_ArmChair_01_F",[-3.61572,-1.61426,0.784058],-142.101],["Land_WoodenBed_01_F",[3.70435,3.92529,0.784073],0.662292],["Land_WoodenBed_01_F",[1.16748,3.84668,0.784073],1.10213],["Land_WoodenBed_01_F",[-1.10559,3.7793,0.784058],-0.971558],["Land_Rug_01_Traditional_F",[0.986694,1.13281,0.784058],-93.231],["Land_LuggageHeap_01_F",[3.32947,0.719727,0.784058],-49.9624],["Land_LuggageHeap_02_F",[2.0238,0.834473,0.784058],-49.9624],["Land_LuggageHeap_03_F",[0.774292,1.04932,0.784058],-49.9624]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 	
			case "Land_i_Shop_01_b_blue_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_i_Shop_02_b_blue_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Small_01_b_white_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]],[["Land_WoodenBed_01_F",[-3.31885,-2.75,-1.04144],92.1606],["Land_WoodenBed_01_F",[-1.74463,0.309326,-1.04109],-0.375671],["Land_Rug_01_F",[-0.359375,-2.61646,-1.04054],94.3338],["Land_TableSmall_01_F",[-4.19873,0.849609,-1.04213],0.487488],["Land_Rug_01_F",[3.29199,1.08911,-1.04071],1.93732],["Land_Rug_01_F",[-2.40967,3.50293,-1.04218],89.6165],["Land_TableBig_01_F",[3.79004,3.36816,-1.04137],268.395],["Land_RattanChair_01_F",[3.70898,1.28931,-1.04076],193.395],["Land_RattanChair_01_F",[2.46338,4.14648,-1.04164],87.8041],["Land_WoodenCounter_01_F",[-2.53711,2.37134,-1.0417],180.924],["Fridge_01_closed_F",[-1.03857,2.48511,-1.04224],180.137],["Land_ShelvesWooden_F",[3.99463,-2.27393,-1.04071],183.013]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
		 
			case "Land_i_House_Small_02_b_white_F":
				{
				_templates = [[["Land_CampingTable_F",[-4.52881,1.90137,-0.588028],3.24768],["Land_CampingChair_V2_F",[-4.48291,1.12305,-0.590683],168.248],["Land_CampingChair_V2_F",[-3.00928,1.77588,-0.588455],-131.752],["Land_WoodenTable_small_F",[-2.12305,-2.80664,-0.590919],87.1347],["Land_OfficeCabinet_01_F",[-1.4624,-0.292969,-0.590393],-90.5812],["Fridge_01_closed_F",[-5.25928,-0.675781,-0.588394],88.6826],["Land_LuggageHeap_01_F",[-1.61865,-1.7002,-0.587791],-161.539],["Land_ShelvesWooden_F",[0.768555,-3.10889,-0.585327],-92.9928],["Land_Basket_F",[-0.217773,-2.94922,-0.585205],-126.326],["Land_CratesShabby_F",[-0.103516,-1.70996,-0.584274],-153.962],["Land_Sack_F",[-0.279297,-0.504883,-0.584274],170.58],["Land_PlasticCase_01_large_F",[4.97168,2.19385,-0.580101],88.9096],["Land_BarrelWater_F",[2.10889,-3.2334,-0.582039],-131.095],["Land_Metal_rack_Tall_F",[1.45605,2.21289,-0.582809],-1.64015],["Land_ChairWood_F",[4.00488,-3.11963,-0.580872],125.577]], [["Land_ShelvesWooden_F",[5.03613,1.45264,-0.58046],-4.37973],["Land_Rug_01_Traditional_F",[2.81396,-0.6604,-0.580338],179.624],["Land_Sofa_01_F",[-0.207031,-1.39795,-0.585907],266.922],["Land_ArmChair_01_F",[1.73047,-2.91113,-0.585495],-0.120544],["Land_TableSmall_01_F",[0.808594,-1.00098,-0.584824],8.17535],["Land_ArmChair_01_F",[4.73779,-0.262207,-0.582794],94.8493],["Land_WoodenBed_01_F",[-2.36133,-2.36279,-0.589874],180.799],["Land_TableBig_01_F",[-4.30518,1.84863,-0.587311],-0.194885],["Land_Rug_01_Traditional_F",[-3.41357,0.0297852,-0.584366],88.2166],["Land_CampingChair_V2_F",[-3.96582,-2.79395,-0.590652],84.4604],["Land_LuggageHeap_01_F",[-4.74902,0.418701,-0.590652],-27.0646],["Land_PlasticCase_01_small_F",[-2.56836,2.16943,-0.585083],90.4173]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_i_House_Big_01_b_white_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_b_white_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_b_white_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_b_white_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]],[["Land_Rug_01_Traditional_F",[1.40527,-4.7912,-2.56494],188.636],["Land_TableBig_01_F",[-1.32227,4.79187,-2.56494],178.995],["Land_TableBig_01_F",[1.01953,4.82434,-2.56494],182.168],["Land_RattanChair_01_F",[2.04199,6.93036,-2.56494],-2.92365],["Land_Sofa_01_F",[1.22656,-6.21259,-2.56494],-3.03351],["Land_Sofa_01_F",[1.24805,-3.53192,-2.56494],173.303],["Land_ArmChair_01_F",[2.34082,-4.90015,-2.56494],84.6665],["Land_WoodenTable_small_F",[1.44531,0.654114,-2.56494],93.0321],["Land_WoodenTable_small_F",[-2.8418,2.09845,-2.56494],266.954],["OfficeTable_01_new_F",[4.16406,-4.82819,0.855063],266.599],["OfficeTable_01_new_F",[1.81348,-6.1449,0.855063],181.904],["Land_OfficeChair_01_F",[3.1582,-4.15515,0.855063],-44.6044],["Land_OfficeChair_01_F",[3.18262,-6.11945,0.855063],256.003],["Land_OfficeCabinet_01_F",[0.0380859,-3.40271,0.855063],-0.0846558],["Land_Metal_rack_Tall_F",[-2.98926,-6.47131,0.855063],175.774],["Land_Metal_rack_Tall_F",[-3.95898,-4.79645,0.855063],85.0273],["Fridge_01_closed_F",[-2.21094,-6.61212,0.855063],179.273],["Land_BarrelWater_F",[-1.55664,-6.50146,0.855063],209.273],["Land_PlasticCase_01_small_F",[-3.87207,-5.76953,0.855063],193.438],["Land_RattanChair_01_F",[0.498047,-2.09833,0.855063],-65.9356],["Land_TablePlastic_01_F",[1.13477,0.201355,0.855063],173.88],["Land_Rug_01_F",[1.33594,5.66254,0.855063],87.9827],["Land_Rug_01_F",[-1.49219,5.07458,0.855063],-4.49963],["Land_WoodenBed_01_F",[1.19141,4.50024,0.855063],178.575],["Land_TableBig_01_F",[-2.66211,6.78253,0.855063],-2.0705]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_02_b_white_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]],[["Land_TableBig_01_F",[4.08276,2.22266,-2.62328],-92.8421],["Land_CampingTable_small_F",[1.41125,0.470703,-2.62326],179.523],["Land_Rug_01_Traditional_F",[0.601929,2.99072,-2.62326],87.6949],["Land_ChairWood_F",[2.95508,1.20898,-2.62328],179.734],["Land_ChairWood_F",[3.73169,3.87988,-2.62326],-92.1608],["Land_Sofa_01_F",[-3.60962,1.43262,-2.62328],-88.6062],["Land_Sofa_01_F",[-2.6637,4.42676,-2.62328],177.932],["Land_TableSmall_01_F",[-2.37988,2.91016,-2.62328],-98.9703],["Land_Metal_rack_Tall_F",[1.01038,-1.12012,-2.62326],2.47485],["Land_Rug_01_Traditional_F",[-2.67651,-2.23047,-2.62328],151.037],["Land_Rug_01_Traditional_F",[-2.14575,-2.67285,0.784058],174.806],["Land_ArmChair_01_F",[-3.91174,-3.4707,0.784058],-86.0274],["Land_ArmChair_01_F",[-3.61572,-1.61426,0.784058],-142.101],["Land_WoodenBed_01_F",[3.70435,3.92529,0.784073],0.662292],["Land_WoodenBed_01_F",[1.16748,3.84668,0.784073],1.10213],["Land_WoodenBed_01_F",[-1.10559,3.7793,0.784058],-0.971558],["Land_Rug_01_Traditional_F",[0.986694,1.13281,0.784058],-93.231],["Land_LuggageHeap_01_F",[3.32947,0.719727,0.784058],-49.9624],["Land_LuggageHeap_02_F",[2.0238,0.834473,0.784058],-49.9624],["Land_LuggageHeap_03_F",[0.774292,1.04932,0.784058],-49.9624]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 	
			case "Land_i_Shop_01_b_white_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_i_Shop_02_b_white_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Small_01_b_brown_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]], [["Land_WoodenBed_01_F",[-3.31885,-2.75,-1.04144],92.1606],["Land_WoodenBed_01_F",[-1.74463,0.309326,-1.04109],-0.375671],["Land_Rug_01_F",[-0.359375,-2.61646,-1.04054],94.3338],["Land_TableSmall_01_F",[-4.19873,0.849609,-1.04213],0.487488],["Land_Rug_01_F",[3.29199,1.08911,-1.04071],1.93732],["Land_Rug_01_F",[-2.40967,3.50293,-1.04218],89.6165],["Land_TableBig_01_F",[3.79004,3.36816,-1.04137],268.395],["Land_RattanChair_01_F",[3.70898,1.28931,-1.04076],193.395],["Land_RattanChair_01_F",[2.46338,4.14648,-1.04164],87.8041],["Land_WoodenCounter_01_F",[-2.53711,2.37134,-1.0417],180.924],["Fridge_01_closed_F",[-1.03857,2.48511,-1.04224],180.137],["Land_ShelvesWooden_F",[3.99463,-2.27393,-1.04071],183.013]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
		 
			case "Land_i_House_Small_02_b_brown_F":
				{
				_templates = [[["Land_CampingTable_F",[-4.52881,1.90137,-0.588028],3.24768],["Land_CampingChair_V2_F",[-4.48291,1.12305,-0.590683],168.248],["Land_CampingChair_V2_F",[-3.00928,1.77588,-0.588455],-131.752],["Land_WoodenTable_small_F",[-2.12305,-2.80664,-0.590919],87.1347],["Land_OfficeCabinet_01_F",[-1.4624,-0.292969,-0.590393],-90.5812],["Fridge_01_closed_F",[-5.25928,-0.675781,-0.588394],88.6826],["Land_LuggageHeap_01_F",[-1.61865,-1.7002,-0.587791],-161.539],["Land_ShelvesWooden_F",[0.768555,-3.10889,-0.585327],-92.9928],["Land_Basket_F",[-0.217773,-2.94922,-0.585205],-126.326],["Land_CratesShabby_F",[-0.103516,-1.70996,-0.584274],-153.962],["Land_Sack_F",[-0.279297,-0.504883,-0.584274],170.58],["Land_PlasticCase_01_large_F",[4.97168,2.19385,-0.580101],88.9096],["Land_BarrelWater_F",[2.10889,-3.2334,-0.582039],-131.095],["Land_Metal_rack_Tall_F",[1.45605,2.21289,-0.582809],-1.64015],["Land_ChairWood_F",[4.00488,-3.11963,-0.580872],125.577]], [["Land_ShelvesWooden_F",[5.03613,1.45264,-0.58046],-4.37973],["Land_Rug_01_Traditional_F",[2.81396,-0.6604,-0.580338],179.624],["Land_Sofa_01_F",[-0.207031,-1.39795,-0.585907],266.922],["Land_ArmChair_01_F",[1.73047,-2.91113,-0.585495],-0.120544],["Land_TableSmall_01_F",[0.808594,-1.00098,-0.584824],8.17535],["Land_ArmChair_01_F",[4.73779,-0.262207,-0.582794],94.8493],["Land_WoodenBed_01_F",[-2.36133,-2.36279,-0.589874],180.799],["Land_TableBig_01_F",[-4.30518,1.84863,-0.587311],-0.194885],["Land_Rug_01_Traditional_F",[-3.41357,0.0297852,-0.584366],88.2166],["Land_CampingChair_V2_F",[-3.96582,-2.79395,-0.590652],84.4604],["Land_LuggageHeap_01_F",[-4.74902,0.418701,-0.590652],-27.0646],["Land_PlasticCase_01_small_F",[-2.56836,2.16943,-0.585083],90.4173]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_i_House_Big_01_b_brown_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_b_brown_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_b_brown_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_b_brown_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]],[["Land_Rug_01_Traditional_F",[1.40527,-4.7912,-2.56494],188.636],["Land_TableBig_01_F",[-1.32227,4.79187,-2.56494],178.995],["Land_TableBig_01_F",[1.01953,4.82434,-2.56494],182.168],["Land_RattanChair_01_F",[2.04199,6.93036,-2.56494],-2.92365],["Land_Sofa_01_F",[1.22656,-6.21259,-2.56494],-3.03351],["Land_Sofa_01_F",[1.24805,-3.53192,-2.56494],173.303],["Land_ArmChair_01_F",[2.34082,-4.90015,-2.56494],84.6665],["Land_WoodenTable_small_F",[1.44531,0.654114,-2.56494],93.0321],["Land_WoodenTable_small_F",[-2.8418,2.09845,-2.56494],266.954],["OfficeTable_01_new_F",[4.16406,-4.82819,0.855063],266.599],["OfficeTable_01_new_F",[1.81348,-6.1449,0.855063],181.904],["Land_OfficeChair_01_F",[3.1582,-4.15515,0.855063],-44.6044],["Land_OfficeChair_01_F",[3.18262,-6.11945,0.855063],256.003],["Land_OfficeCabinet_01_F",[0.0380859,-3.40271,0.855063],-0.0846558],["Land_Metal_rack_Tall_F",[-2.98926,-6.47131,0.855063],175.774],["Land_Metal_rack_Tall_F",[-3.95898,-4.79645,0.855063],85.0273],["Fridge_01_closed_F",[-2.21094,-6.61212,0.855063],179.273],["Land_BarrelWater_F",[-1.55664,-6.50146,0.855063],209.273],["Land_PlasticCase_01_small_F",[-3.87207,-5.76953,0.855063],193.438],["Land_RattanChair_01_F",[0.498047,-2.09833,0.855063],-65.9356],["Land_TablePlastic_01_F",[1.13477,0.201355,0.855063],173.88],["Land_Rug_01_F",[1.33594,5.66254,0.855063],87.9827],["Land_Rug_01_F",[-1.49219,5.07458,0.855063],-4.49963],["Land_WoodenBed_01_F",[1.19141,4.50024,0.855063],178.575],["Land_TableBig_01_F",[-2.66211,6.78253,0.855063],-2.0705]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_02_b_brown_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]],[["Land_TableBig_01_F",[4.08276,2.22266,-2.62328],-92.8421],["Land_CampingTable_small_F",[1.41125,0.470703,-2.62326],179.523],["Land_Rug_01_Traditional_F",[0.601929,2.99072,-2.62326],87.6949],["Land_ChairWood_F",[2.95508,1.20898,-2.62328],179.734],["Land_ChairWood_F",[3.73169,3.87988,-2.62326],-92.1608],["Land_Sofa_01_F",[-3.60962,1.43262,-2.62328],-88.6062],["Land_Sofa_01_F",[-2.6637,4.42676,-2.62328],177.932],["Land_TableSmall_01_F",[-2.37988,2.91016,-2.62328],-98.9703],["Land_Metal_rack_Tall_F",[1.01038,-1.12012,-2.62326],2.47485],["Land_Rug_01_Traditional_F",[-2.67651,-2.23047,-2.62328],151.037],["Land_Rug_01_Traditional_F",[-2.14575,-2.67285,0.784058],174.806],["Land_ArmChair_01_F",[-3.91174,-3.4707,0.784058],-86.0274],["Land_ArmChair_01_F",[-3.61572,-1.61426,0.784058],-142.101],["Land_WoodenBed_01_F",[3.70435,3.92529,0.784073],0.662292],["Land_WoodenBed_01_F",[1.16748,3.84668,0.784073],1.10213],["Land_WoodenBed_01_F",[-1.10559,3.7793,0.784058],-0.971558],["Land_Rug_01_Traditional_F",[0.986694,1.13281,0.784058],-93.231],["Land_LuggageHeap_01_F",[3.32947,0.719727,0.784058],-49.9624],["Land_LuggageHeap_02_F",[2.0238,0.834473,0.784058],-49.9624],["Land_LuggageHeap_03_F",[0.774292,1.04932,0.784058],-49.9624]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 	
			case "Land_i_Shop_01_b_brown_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_i_Shop_02_b_brown_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			case "Land_i_House_Small_01_b_pink_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]],[["Land_WoodenBed_01_F",[-3.31885,-2.75,-1.04144],92.1606],["Land_WoodenBed_01_F",[-1.74463,0.309326,-1.04109],-0.375671],["Land_Rug_01_F",[-0.359375,-2.61646,-1.04054],94.3338],["Land_TableSmall_01_F",[-4.19873,0.849609,-1.04213],0.487488],["Land_Rug_01_F",[3.29199,1.08911,-1.04071],1.93732],["Land_Rug_01_F",[-2.40967,3.50293,-1.04218],89.6165],["Land_TableBig_01_F",[3.79004,3.36816,-1.04137],268.395],["Land_RattanChair_01_F",[3.70898,1.28931,-1.04076],193.395],["Land_RattanChair_01_F",[2.46338,4.14648,-1.04164],87.8041],["Land_WoodenCounter_01_F",[-2.53711,2.37134,-1.0417],180.924],["Fridge_01_closed_F",[-1.03857,2.48511,-1.04224],180.137],["Land_ShelvesWooden_F",[3.99463,-2.27393,-1.04071],183.013]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
		 
			case "Land_i_House_Small_02_b_pink_F":
				{
				_templates = [[["Land_CampingTable_F",[-4.52881,1.90137,-0.588028],3.24768],["Land_CampingChair_V2_F",[-4.48291,1.12305,-0.590683],168.248],["Land_CampingChair_V2_F",[-3.00928,1.77588,-0.588455],-131.752],["Land_WoodenTable_small_F",[-2.12305,-2.80664,-0.590919],87.1347],["Land_OfficeCabinet_01_F",[-1.4624,-0.292969,-0.590393],-90.5812],["Fridge_01_closed_F",[-5.25928,-0.675781,-0.588394],88.6826],["Land_LuggageHeap_01_F",[-1.61865,-1.7002,-0.587791],-161.539],["Land_ShelvesWooden_F",[0.768555,-3.10889,-0.585327],-92.9928],["Land_Basket_F",[-0.217773,-2.94922,-0.585205],-126.326],["Land_CratesShabby_F",[-0.103516,-1.70996,-0.584274],-153.962],["Land_Sack_F",[-0.279297,-0.504883,-0.584274],170.58],["Land_PlasticCase_01_large_F",[4.97168,2.19385,-0.580101],88.9096],["Land_BarrelWater_F",[2.10889,-3.2334,-0.582039],-131.095],["Land_Metal_rack_Tall_F",[1.45605,2.21289,-0.582809],-1.64015],["Land_ChairWood_F",[4.00488,-3.11963,-0.580872],125.577]], [["Land_ShelvesWooden_F",[5.03613,1.45264,-0.58046],-4.37973],["Land_Rug_01_Traditional_F",[2.81396,-0.6604,-0.580338],179.624],["Land_Sofa_01_F",[-0.207031,-1.39795,-0.585907],266.922],["Land_ArmChair_01_F",[1.73047,-2.91113,-0.585495],-0.120544],["Land_TableSmall_01_F",[0.808594,-1.00098,-0.584824],8.17535],["Land_ArmChair_01_F",[4.73779,-0.262207,-0.582794],94.8493],["Land_WoodenBed_01_F",[-2.36133,-2.36279,-0.589874],180.799],["Land_TableBig_01_F",[-4.30518,1.84863,-0.587311],-0.194885],["Land_Rug_01_Traditional_F",[-3.41357,0.0297852,-0.584366],88.2166],["Land_CampingChair_V2_F",[-3.96582,-2.79395,-0.590652],84.4604],["Land_LuggageHeap_01_F",[-4.74902,0.418701,-0.590652],-27.0646],["Land_PlasticCase_01_small_F",[-2.56836,2.16943,-0.585083],90.4173]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_i_House_Big_01_b_pink_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_b_pink_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_b_pink_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_b_pink_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]], [["Land_Rug_01_Traditional_F",[1.40527,-4.7912,-2.56494],188.636],["Land_TableBig_01_F",[-1.32227,4.79187,-2.56494],178.995],["Land_TableBig_01_F",[1.01953,4.82434,-2.56494],182.168],["Land_RattanChair_01_F",[2.04199,6.93036,-2.56494],-2.92365],["Land_Sofa_01_F",[1.22656,-6.21259,-2.56494],-3.03351],["Land_Sofa_01_F",[1.24805,-3.53192,-2.56494],173.303],["Land_ArmChair_01_F",[2.34082,-4.90015,-2.56494],84.6665],["Land_WoodenTable_small_F",[1.44531,0.654114,-2.56494],93.0321],["Land_WoodenTable_small_F",[-2.8418,2.09845,-2.56494],266.954],["OfficeTable_01_new_F",[4.16406,-4.82819,0.855063],266.599],["OfficeTable_01_new_F",[1.81348,-6.1449,0.855063],181.904],["Land_OfficeChair_01_F",[3.1582,-4.15515,0.855063],-44.6044],["Land_OfficeChair_01_F",[3.18262,-6.11945,0.855063],256.003],["Land_OfficeCabinet_01_F",[0.0380859,-3.40271,0.855063],-0.0846558],["Land_Metal_rack_Tall_F",[-2.98926,-6.47131,0.855063],175.774],["Land_Metal_rack_Tall_F",[-3.95898,-4.79645,0.855063],85.0273],["Fridge_01_closed_F",[-2.21094,-6.61212,0.855063],179.273],["Land_BarrelWater_F",[-1.55664,-6.50146,0.855063],209.273],["Land_PlasticCase_01_small_F",[-3.87207,-5.76953,0.855063],193.438],["Land_RattanChair_01_F",[0.498047,-2.09833,0.855063],-65.9356],["Land_TablePlastic_01_F",[1.13477,0.201355,0.855063],173.88],["Land_Rug_01_F",[1.33594,5.66254,0.855063],87.9827],["Land_Rug_01_F",[-1.49219,5.07458,0.855063],-4.49963],["Land_WoodenBed_01_F",[1.19141,4.50024,0.855063],178.575],["Land_TableBig_01_F",[-2.66211,6.78253,0.855063],-2.0705]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_02_b_pink_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]], [["Land_TableBig_01_F",[4.08276,2.22266,-2.62328],-92.8421],["Land_CampingTable_small_F",[1.41125,0.470703,-2.62326],179.523],["Land_Rug_01_Traditional_F",[0.601929,2.99072,-2.62326],87.6949],["Land_ChairWood_F",[2.95508,1.20898,-2.62328],179.734],["Land_ChairWood_F",[3.73169,3.87988,-2.62326],-92.1608],["Land_Sofa_01_F",[-3.60962,1.43262,-2.62328],-88.6062],["Land_Sofa_01_F",[-2.6637,4.42676,-2.62328],177.932],["Land_TableSmall_01_F",[-2.37988,2.91016,-2.62328],-98.9703],["Land_Metal_rack_Tall_F",[1.01038,-1.12012,-2.62326],2.47485],["Land_Rug_01_Traditional_F",[-2.67651,-2.23047,-2.62328],151.037],["Land_Rug_01_Traditional_F",[-2.14575,-2.67285,0.784058],174.806],["Land_ArmChair_01_F",[-3.91174,-3.4707,0.784058],-86.0274],["Land_ArmChair_01_F",[-3.61572,-1.61426,0.784058],-142.101],["Land_WoodenBed_01_F",[3.70435,3.92529,0.784073],0.662292],["Land_WoodenBed_01_F",[1.16748,3.84668,0.784073],1.10213],["Land_WoodenBed_01_F",[-1.10559,3.7793,0.784058],-0.971558],["Land_Rug_01_Traditional_F",[0.986694,1.13281,0.784058],-93.231],["Land_LuggageHeap_01_F",[3.32947,0.719727,0.784058],-49.9624],["Land_LuggageHeap_02_F",[2.0238,0.834473,0.784058],-49.9624],["Land_LuggageHeap_03_F",[0.774292,1.04932,0.784058],-49.9624]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 	
			case "Land_i_Shop_01_b_pink_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_i_Shop_02_b_pink_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			case "Land_i_House_Small_01_b_yellow_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]],[["Land_WoodenBed_01_F",[-3.31885,-2.75,-1.04144],92.1606],["Land_WoodenBed_01_F",[-1.74463,0.309326,-1.04109],-0.375671],["Land_Rug_01_F",[-0.359375,-2.61646,-1.04054],94.3338],["Land_TableSmall_01_F",[-4.19873,0.849609,-1.04213],0.487488],["Land_Rug_01_F",[3.29199,1.08911,-1.04071],1.93732],["Land_Rug_01_F",[-2.40967,3.50293,-1.04218],89.6165],["Land_TableBig_01_F",[3.79004,3.36816,-1.04137],268.395],["Land_RattanChair_01_F",[3.70898,1.28931,-1.04076],193.395],["Land_RattanChair_01_F",[2.46338,4.14648,-1.04164],87.8041],["Land_WoodenCounter_01_F",[-2.53711,2.37134,-1.0417],180.924],["Fridge_01_closed_F",[-1.03857,2.48511,-1.04224],180.137],["Land_ShelvesWooden_F",[3.99463,-2.27393,-1.04071],183.013]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
		 
			case "Land_i_House_Small_02_b_yellow_F":
				{
				_templates = [[["Land_CampingTable_F",[-4.52881,1.90137,-0.588028],3.24768],["Land_CampingChair_V2_F",[-4.48291,1.12305,-0.590683],168.248],["Land_CampingChair_V2_F",[-3.00928,1.77588,-0.588455],-131.752],["Land_WoodenTable_small_F",[-2.12305,-2.80664,-0.590919],87.1347],["Land_OfficeCabinet_01_F",[-1.4624,-0.292969,-0.590393],-90.5812],["Fridge_01_closed_F",[-5.25928,-0.675781,-0.588394],88.6826],["Land_LuggageHeap_01_F",[-1.61865,-1.7002,-0.587791],-161.539],["Land_ShelvesWooden_F",[0.768555,-3.10889,-0.585327],-92.9928],["Land_Basket_F",[-0.217773,-2.94922,-0.585205],-126.326],["Land_CratesShabby_F",[-0.103516,-1.70996,-0.584274],-153.962],["Land_Sack_F",[-0.279297,-0.504883,-0.584274],170.58],["Land_PlasticCase_01_large_F",[4.97168,2.19385,-0.580101],88.9096],["Land_BarrelWater_F",[2.10889,-3.2334,-0.582039],-131.095],["Land_Metal_rack_Tall_F",[1.45605,2.21289,-0.582809],-1.64015],["Land_ChairWood_F",[4.00488,-3.11963,-0.580872],125.577]],[["Land_ShelvesWooden_F",[5.03613,1.45264,-0.58046],-4.37973],["Land_Rug_01_Traditional_F",[2.81396,-0.6604,-0.580338],179.624],["Land_Sofa_01_F",[-0.207031,-1.39795,-0.585907],266.922],["Land_ArmChair_01_F",[1.73047,-2.91113,-0.585495],-0.120544],["Land_TableSmall_01_F",[0.808594,-1.00098,-0.584824],8.17535],["Land_ArmChair_01_F",[4.73779,-0.262207,-0.582794],94.8493],["Land_WoodenBed_01_F",[-2.36133,-2.36279,-0.589874],180.799],["Land_TableBig_01_F",[-4.30518,1.84863,-0.587311],-0.194885],["Land_Rug_01_Traditional_F",[-3.41357,0.0297852,-0.584366],88.2166],["Land_CampingChair_V2_F",[-3.96582,-2.79395,-0.590652],84.4604],["Land_LuggageHeap_01_F",[-4.74902,0.418701,-0.590652],-27.0646],["Land_PlasticCase_01_small_F",[-2.56836,2.16943,-0.585083],90.4173]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_i_House_Big_01_b_yellow_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_b_yellow_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_b_yellow_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_b_yellow_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]], [["Land_Rug_01_Traditional_F",[1.40527,-4.7912,-2.56494],188.636],["Land_TableBig_01_F",[-1.32227,4.79187,-2.56494],178.995],["Land_TableBig_01_F",[1.01953,4.82434,-2.56494],182.168],["Land_RattanChair_01_F",[2.04199,6.93036,-2.56494],-2.92365],["Land_Sofa_01_F",[1.22656,-6.21259,-2.56494],-3.03351],["Land_Sofa_01_F",[1.24805,-3.53192,-2.56494],173.303],["Land_ArmChair_01_F",[2.34082,-4.90015,-2.56494],84.6665],["Land_WoodenTable_small_F",[1.44531,0.654114,-2.56494],93.0321],["Land_WoodenTable_small_F",[-2.8418,2.09845,-2.56494],266.954],["OfficeTable_01_new_F",[4.16406,-4.82819,0.855063],266.599],["OfficeTable_01_new_F",[1.81348,-6.1449,0.855063],181.904],["Land_OfficeChair_01_F",[3.1582,-4.15515,0.855063],-44.6044],["Land_OfficeChair_01_F",[3.18262,-6.11945,0.855063],256.003],["Land_OfficeCabinet_01_F",[0.0380859,-3.40271,0.855063],-0.0846558],["Land_Metal_rack_Tall_F",[-2.98926,-6.47131,0.855063],175.774],["Land_Metal_rack_Tall_F",[-3.95898,-4.79645,0.855063],85.0273],["Fridge_01_closed_F",[-2.21094,-6.61212,0.855063],179.273],["Land_BarrelWater_F",[-1.55664,-6.50146,0.855063],209.273],["Land_PlasticCase_01_small_F",[-3.87207,-5.76953,0.855063],193.438],["Land_RattanChair_01_F",[0.498047,-2.09833,0.855063],-65.9356],["Land_TablePlastic_01_F",[1.13477,0.201355,0.855063],173.88],["Land_Rug_01_F",[1.33594,5.66254,0.855063],87.9827],["Land_Rug_01_F",[-1.49219,5.07458,0.855063],-4.49963],["Land_WoodenBed_01_F",[1.19141,4.50024,0.855063],178.575],["Land_TableBig_01_F",[-2.66211,6.78253,0.855063],-2.0705]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_02_b_yellow_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]],[["Land_TableBig_01_F",[4.08276,2.22266,-2.62328],-92.8421],["Land_CampingTable_small_F",[1.41125,0.470703,-2.62326],179.523],["Land_Rug_01_Traditional_F",[0.601929,2.99072,-2.62326],87.6949],["Land_ChairWood_F",[2.95508,1.20898,-2.62328],179.734],["Land_ChairWood_F",[3.73169,3.87988,-2.62326],-92.1608],["Land_Sofa_01_F",[-3.60962,1.43262,-2.62328],-88.6062],["Land_Sofa_01_F",[-2.6637,4.42676,-2.62328],177.932],["Land_TableSmall_01_F",[-2.37988,2.91016,-2.62328],-98.9703],["Land_Metal_rack_Tall_F",[1.01038,-1.12012,-2.62326],2.47485],["Land_Rug_01_Traditional_F",[-2.67651,-2.23047,-2.62328],151.037],["Land_Rug_01_Traditional_F",[-2.14575,-2.67285,0.784058],174.806],["Land_ArmChair_01_F",[-3.91174,-3.4707,0.784058],-86.0274],["Land_ArmChair_01_F",[-3.61572,-1.61426,0.784058],-142.101],["Land_WoodenBed_01_F",[3.70435,3.92529,0.784073],0.662292],["Land_WoodenBed_01_F",[1.16748,3.84668,0.784073],1.10213],["Land_WoodenBed_01_F",[-1.10559,3.7793,0.784058],-0.971558],["Land_Rug_01_Traditional_F",[0.986694,1.13281,0.784058],-93.231],["Land_LuggageHeap_01_F",[3.32947,0.719727,0.784058],-49.9624],["Land_LuggageHeap_02_F",[2.0238,0.834473,0.784058],-49.9624],["Land_LuggageHeap_03_F",[0.774292,1.04932,0.784058],-49.9624]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 	
			case "Land_i_Shop_01_b_yellow_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_i_Shop_02_b_yellow_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Small_01_b_whiteblue_F":
				{
				_templates = [[["Land_CanisterPlastic_F",[2.08398,4.49023,-1.03958],46.0271],["Land_ChairPlastic_F",[3.7832,4.11719,-1.07374],-119.167],["Land_ChairPlastic_F",[-4.08203,-3.82422,-1.02398],35.2988],["Land_TablePlastic_01_F",[-3.9375,-0.464844,-1.0852],88.3407],["Land_ChairPlastic_F",[-2.68652,-0.84375,-1.07325],157.217],["Land_ChairPlastic_F",[-2.85938,0.480469,-1.02343],187.217],["Land_WoodenTable_large_F",[0.878906,-2.44531,-1.02346],1.58008],["Land_RattanChair_01_F",[0.158203,-2.23047,-1.04972],46.5948],["Land_PlasticCase_01_small_F",[0.764648,-2.24219,-0.147858],23.7305],["Land_Sack_F",[-0.423828,4.31641,-1.03956],45.0582],["Land_Sack_F",[-1.82422,4.45703,-1.03967],150.058],["Land_Basket_F",[-1.30469,0.972656,-1.18567],-106.466],["Fridge_01_closed_F",[-1.40723,-3.88477,-1.15955],176.421]], [["Land_WoodenBed_01_F",[-3.31885,-2.75,-1.04144],92.1606],["Land_WoodenBed_01_F",[-1.74463,0.309326,-1.04109],-0.375671],["Land_Rug_01_F",[-0.359375,-2.61646,-1.04054],94.3338],["Land_TableSmall_01_F",[-4.19873,0.849609,-1.04213],0.487488],["Land_Rug_01_F",[3.29199,1.08911,-1.04071],1.93732],["Land_Rug_01_F",[-2.40967,3.50293,-1.04218],89.6165],["Land_TableBig_01_F",[3.79004,3.36816,-1.04137],268.395],["Land_RattanChair_01_F",[3.70898,1.28931,-1.04076],193.395],["Land_RattanChair_01_F",[2.46338,4.14648,-1.04164],87.8041],["Land_WoodenCounter_01_F",[-2.53711,2.37134,-1.0417],180.924],["Fridge_01_closed_F",[-1.03857,2.48511,-1.04224],180.137],["Land_ShelvesWooden_F",[3.99463,-2.27393,-1.04071],183.013]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			
		 
			case "Land_i_House_Small_02_b_whiteblue_F":
				{
				_templates = [[["Land_CampingTable_F",[-4.52881,1.90137,-0.588028],3.24768],["Land_CampingChair_V2_F",[-4.48291,1.12305,-0.590683],168.248],["Land_CampingChair_V2_F",[-3.00928,1.77588,-0.588455],-131.752],["Land_WoodenTable_small_F",[-2.12305,-2.80664,-0.590919],87.1347],["Land_OfficeCabinet_01_F",[-1.4624,-0.292969,-0.590393],-90.5812],["Fridge_01_closed_F",[-5.25928,-0.675781,-0.588394],88.6826],["Land_LuggageHeap_01_F",[-1.61865,-1.7002,-0.587791],-161.539],["Land_ShelvesWooden_F",[0.768555,-3.10889,-0.585327],-92.9928],["Land_Basket_F",[-0.217773,-2.94922,-0.585205],-126.326],["Land_CratesShabby_F",[-0.103516,-1.70996,-0.584274],-153.962],["Land_Sack_F",[-0.279297,-0.504883,-0.584274],170.58],["Land_PlasticCase_01_large_F",[4.97168,2.19385,-0.580101],88.9096],["Land_BarrelWater_F",[2.10889,-3.2334,-0.582039],-131.095],["Land_Metal_rack_Tall_F",[1.45605,2.21289,-0.582809],-1.64015],["Land_ChairWood_F",[4.00488,-3.11963,-0.580872],125.577]],[["Land_ShelvesWooden_F",[5.03613,1.45264,-0.58046],-4.37973],["Land_Rug_01_Traditional_F",[2.81396,-0.6604,-0.580338],179.624],["Land_Sofa_01_F",[-0.207031,-1.39795,-0.585907],266.922],["Land_ArmChair_01_F",[1.73047,-2.91113,-0.585495],-0.120544],["Land_TableSmall_01_F",[0.808594,-1.00098,-0.584824],8.17535],["Land_ArmChair_01_F",[4.73779,-0.262207,-0.582794],94.8493],["Land_WoodenBed_01_F",[-2.36133,-2.36279,-0.589874],180.799],["Land_TableBig_01_F",[-4.30518,1.84863,-0.587311],-0.194885],["Land_Rug_01_Traditional_F",[-3.41357,0.0297852,-0.584366],88.2166],["Land_CampingChair_V2_F",[-3.96582,-2.79395,-0.590652],84.4604],["Land_LuggageHeap_01_F",[-4.74902,0.418701,-0.590652],-27.0646],["Land_PlasticCase_01_small_F",[-2.56836,2.16943,-0.585083],90.4173]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_i_House_Big_01_b_whiteblue_F":
				{
				_templates =  [[["Land_TablePlastic_01_F",[-0.279297,6.46289,-2.56494],-1.34801],["Land_ChairPlastic_F",[-1.7832,6.5752,-2.56494],-2.40092],["Land_ChairPlastic_F",[-0.296875,5.48828,-2.56494],83.7812],["Land_ChairPlastic_F",[1.53516,5.89844,-2.56494],158.718],["Land_WoodenTable_small_F",[-3.31641,3.84277,-2.56494],-87.8386],["Land_OfficeCabinet_01_F",[-3.44141,6.89551,-2.56494],0.909653],["OfficeTable_01_new_F",[3.79883,3.84375,-2.56494],0.0835114],["Land_CampingChair_b_whiteblue_F",[2.08691,3.57324,-2.56494],-179.825],["Fridge_01_closed_F",[-3.81738,1.63281,-2.56494],96.9639],["Land_BarrelWater_F",[-3.84668,2.35742,-2.56494],64.9382],["Land_WoodenTable_large_F",[1.39258,-0.125977,-2.56494],0.560516],["Land_ChairWood_F",[0.290039,-0.0556641,-2.56494],146.572],["Land_ChairWood_F",[1.24316,-1.74121,-2.56494],-188.069],["Land_ChairWood_F",[2.2627,-0.65918,-2.56494],-98.0686],["Land_WoodenCounter_01_F",[-1.12305,-2.81348,-2.56494],-90.0677],["Land_Metal_rack_F",[1.48145,-6.75977,-2.56494],-179.451],["Land_Metal_rack_Tall_F",[4.22559,-3.98535,-2.56494],-92.7952],["Land_LuggageHeap_01_F",[3.68945,-3.7207,0.855064],-58.1014],["Land_PlasticCase_01_large_F",[1.82031,-6.79102,0.855064],-90.0129],["Land_Suitcase_F",[4.0957,-6.70996,0.855064],19.5407],["Land_Sleeping_bag_F",[2.91797,-5.13184,0.855064],56.2859],["Land_Sleeping_bag_blue_folded_F",[3.84668,-4.60449,0.855064],65.0301],["Land_Ground_sheet_folded_F",[1.4502,-3.76074,0.855064],81.098],["Land_FMradio_F",[2.75195,-6.65527,0.855064],32.7554],["Land_CampingTable_small_F",[-1.75977,-6.37012,0.855064],-0.760391],["Land_CampingChair_b_whiteblue_F",[-1.91211,-5.57031,0.855064],3.5764],["Land_CampingChair_b_whiteblue_F",[-2.87891,-6.31641,0.855064],63.5764],["Land_ShelvesWooden_F",[4.18848,-1.94336,0.855064],-179.129],["Land_Sack_F",[2.32324,0.673828,0.855064],-141.559],["Land_Sack_F",[2.17188,-0.499023,0.855064],-105.913],["Land_Sacks_goods_F",[1.00977,-1.98047,0.855064],-177.147],["Land_CanisterPlastic_F",[-3.76758,2.36816,0.855066],-5.05688],["Land_CanisterPlastic_F",[-3.91016,-1.09863,0.855064],39.9431],["Land_GasTank_01_blue_F",[0.870117,0.0986328,0.855064],-61.4245]],[["Land_Rug_01_Traditional_F",[1.40527,-4.7912,-2.56494],188.636],["Land_TableBig_01_F",[-1.32227,4.79187,-2.56494],178.995],["Land_TableBig_01_F",[1.01953,4.82434,-2.56494],182.168],["Land_RattanChair_01_F",[2.04199,6.93036,-2.56494],-2.92365],["Land_Sofa_01_F",[1.22656,-6.21259,-2.56494],-3.03351],["Land_Sofa_01_F",[1.24805,-3.53192,-2.56494],173.303],["Land_ArmChair_01_F",[2.34082,-4.90015,-2.56494],84.6665],["Land_WoodenTable_small_F",[1.44531,0.654114,-2.56494],93.0321],["Land_WoodenTable_small_F",[-2.8418,2.09845,-2.56494],266.954],["OfficeTable_01_new_F",[4.16406,-4.82819,0.855063],266.599],["OfficeTable_01_new_F",[1.81348,-6.1449,0.855063],181.904],["Land_OfficeChair_01_F",[3.1582,-4.15515,0.855063],-44.6044],["Land_OfficeChair_01_F",[3.18262,-6.11945,0.855063],256.003],["Land_OfficeCabinet_01_F",[0.0380859,-3.40271,0.855063],-0.0846558],["Land_Metal_rack_Tall_F",[-2.98926,-6.47131,0.855063],175.774],["Land_Metal_rack_Tall_F",[-3.95898,-4.79645,0.855063],85.0273],["Fridge_01_closed_F",[-2.21094,-6.61212,0.855063],179.273],["Land_BarrelWater_F",[-1.55664,-6.50146,0.855063],209.273],["Land_PlasticCase_01_small_F",[-3.87207,-5.76953,0.855063],193.438],["Land_RattanChair_01_F",[0.498047,-2.09833,0.855063],-65.9356],["Land_TablePlastic_01_F",[1.13477,0.201355,0.855063],173.88],["Land_Rug_01_F",[1.33594,5.66254,0.855063],87.9827],["Land_Rug_01_F",[-1.49219,5.07458,0.855063],-4.49963],["Land_WoodenBed_01_F",[1.19141,4.50024,0.855063],178.575],["Land_TableBig_01_F",[-2.66211,6.78253,0.855063],-2.0705]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_i_House_Big_02_b_whiteblue_F":
				{
				_templates = [[["Fridge_01_closed_F",[2.12891,-1.1084,-2.62491],-94.3556],["Land_Basket_F",[1.83203,-1.92969,-2.62556],-106.438],["Land_ShelvesWooden_F",[-3.38086,-1.18848,-2.6199],90.0902],["Land_ShelvesMetal_F",[1.80664,0.173828,-2.6269],-89.9523],["Land_ShelvesWooden_F",[4.19531,0.828125,-2.62674],-4.50794],["Land_TableDesk_F",[4.08984,3.54492,-2.62547],90.2152],["Land_OfficeChair_01_F",[2.99219,3.5459,-2.62547],90.2152],["Land_OfficeChair_01_F",[4.18359,1.91211,-2.62514],-203.348],["Land_WoodenCounter_01_F",[-4.02344,2.15625,-2.6219],90.2379],["Land_ChairWood_F",[-3.32422,4.33008,-2.62135],35.4309],["Land_CanisterPlastic_F",[-3.94336,0.236328,-2.6234],69.1718],["Land_CanisterPlastic_F",[-3.85547,-1.22266,0.787415],0.607124],["Land_CanisterPlastic_F",[-3.81055,-1.83594,0.787415],30.6071],["Land_CanisterPlastic_F",[-3.80469,-2.80664,0.787415],75.6071],["Land_GasTank_01_blue_F",[-3.82422,-3.73633,0.786346],103.539],["Land_PlasticCase_01_large_F",[2.38477,0.078125,0.780411],-97.4489],["Land_BarrelWater_F",[4.38086,0.0273438,0.780487],-85.2888],["Land_Sacks_heap_F",[3.78906,1.19043,0.780487],-85.2888],["Land_Sacks_heap_F",[3.85352,3.10742,0.781708],87.4758],["Land_Sleeping_bag_blue_folded_F",[1.67969,4.63672,0.784164],-231.154],["Land_Sleeping_bag_blue_folded_F",[2.46094,4.43945,0.784164],-201.154],["Land_LuggageHeap_02_F",[-0.681641,4.61914,0.787247],-142.198],["Land_CratesShabby_F",[-3.80078,0.439453,0.784561],-30.6144],["Land_Sack_F",[-3.97266,1.52148,0.784927],-51.4324],["Land_ChairWood_F",[1.04102,0.108398,0.780457],-193.077],["Land_WoodenTable_small_F",[-1.17578,-3.37305,0.782806],87.3334]],[["Land_TableBig_01_F",[4.08276,2.22266,-2.62328],-92.8421],["Land_CampingTable_small_F",[1.41125,0.470703,-2.62326],179.523],["Land_Rug_01_Traditional_F",[0.601929,2.99072,-2.62326],87.6949],["Land_ChairWood_F",[2.95508,1.20898,-2.62328],179.734],["Land_ChairWood_F",[3.73169,3.87988,-2.62326],-92.1608],["Land_Sofa_01_F",[-3.60962,1.43262,-2.62328],-88.6062],["Land_Sofa_01_F",[-2.6637,4.42676,-2.62328],177.932],["Land_TableSmall_01_F",[-2.37988,2.91016,-2.62328],-98.9703],["Land_Metal_rack_Tall_F",[1.01038,-1.12012,-2.62326],2.47485],["Land_Rug_01_Traditional_F",[-2.67651,-2.23047,-2.62328],151.037],["Land_Rug_01_Traditional_F",[-2.14575,-2.67285,0.784058],174.806],["Land_ArmChair_01_F",[-3.91174,-3.4707,0.784058],-86.0274],["Land_ArmChair_01_F",[-3.61572,-1.61426,0.784058],-142.101],["Land_WoodenBed_01_F",[3.70435,3.92529,0.784073],0.662292],["Land_WoodenBed_01_F",[1.16748,3.84668,0.784073],1.10213],["Land_WoodenBed_01_F",[-1.10559,3.7793,0.784058],-0.971558],["Land_Rug_01_Traditional_F",[0.986694,1.13281,0.784058],-93.231],["Land_LuggageHeap_01_F",[3.32947,0.719727,0.784058],-49.9624],["Land_LuggageHeap_02_F",[2.0238,0.834473,0.784058],-49.9624],["Land_LuggageHeap_03_F",[0.774292,1.04932,0.784058],-49.9624]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
 	
			case "Land_i_Shop_01_b_whiteblue_F":
				{
				_templates =  [[["Land_ShelvesMetal_F",[-1.84546,0.521484,-2.76157],-0.0969238],["Land_ShelvesMetal_F",[1.35376,1.49023,-2.76157],177.141],["Land_CashDesk_F",[-2.81934,4.38867,-2.76157],-1.98949],["Land_OfficeChair_01_F",[-2.66797,5.48828,-2.76158],52.5127],["Fridge_01_closed_F",[3.04639,4.69727,-2.76157],182.912],["Land_ShelvesWooden_F",[-3.10693,6.19922,1.10981],182.241],["Land_WoodenCounter_01_F",[1.44971,0.595703,1.10873],-91.404],["Land_WoodenTable_large_F",[-2.93579,2.07227,1.10927],179.546],["Land_CampingChair_V2_F",[-1.72656,2.06836,1.1089],-120.454],["Land_CampingChair_V2_F",[-2.604,0.347656,1.1095],145.662],["Land_LuggageHeap_02_F",[-2.92627,3.92969,1.10938],103.453]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_i_Shop_02_b_whiteblue_F":
				{
				_templates =  [[["Land_Sacks_heap_F",[-1.2666,-3.29004,-2.66902],-58.4311],["Land_Sacks_heap_F",[-0.532227,-0.748779,-2.67464],1.56894],["Land_Sacks_goods_F",[2.1123,-2.18286,-2.67087],24.3402],["Land_Sacks_goods_F",[-3.8877,3.24756,-2.6676],-10.5067],["Land_Sack_F",[-3.05078,-3.62305,-2.68017],-184.254],["Land_WoodenCounter_01_F",[-2.94922,-3.90747,1.23761],-179.59],["Land_CampingChair_V2_F",[-1.03711,0.518066,1.23843],-36.8381],["Land_CampingChair_V2_F",[-0.660156,-2.07642,1.23843],38.1618],["Land_CampingTable_small_F",[-2.09277,-1.02124,1.23843],98.1618]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			// LIVONIA	
			case "Land_VillageStore_01_F":
				{
				_templates = [[["Land_CashDesk_F",[5.87427,3.22949,-1.84026],5.17387],["Land_Icebox_F",[7.19067,-0.412598,-1.84026],-89.9325],["Land_ShelvesMetal_F",[2.99634,1.3208,-1.84026],2.33439],["Land_ShelvesMetal_F",[2.43774,-1.03906,-1.84026],-270.137],["Land_Sack_F",[7.24097,4.70996,-1.84026],-74.0352],["Land_OfficeChair_01_F",[6.23413,4.46387,-1.84026],-74.0352],["Land_Metal_rack_F",[7.21558,7.1123,-1.84026],-93.0006],["Land_Metal_rack_Tall_F",[5.38647,6.04297,-1.84026],-181.985],["Land_ShelvesMetal_F",[5.56836,8.2666,-1.84026],-90.9272],["Land_Sacks_goods_F",[5.67822,7.07031,-1.84026],-97.8521]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_House_2B01_F":
				{
				_templates = [[["Land_ArmChair_01_F",[-1.90454,4.20557,-4.18092],-173.924],["Land_WoodenBed_01_F",[-4.00085,2.87744,-4.18092],96.0765],["Land_ArmChair_01_F",[-0.716797,1.09717,-4.18092],-2.36528],["Land_Rug_01_Traditional_F",[1.24695,2.44678,-4.18092],-79.5206],["Land_Rug_01_Traditional_F",[-0.201904,-3.39502,-4.18092],90.584],["Land_CampingTable_F",[-0.129395,-2.65234,-4.18092],181.448],["Land_CampingChair_V2_F",[-0.103271,-3.65576,-4.18092],181.448],["Land_CampingChair_V2_F",[-1.28235,-3.43457,-4.18092],148.913],["Land_ShelvesWooden_F",[2.30884,-1.04297,-1.01825],-2.69267],["Land_Metal_rack_F",[-3.52515,0.677734,-1.02176],173.464],["Land_Metal_rack_Tall_F",[-4.44141,2.05859,-1.02176],90.1393],["Land_ShelvesWooden_F",[-4.57483,4.33984,-1.02176],-172.524],["Land_LuggageHeap_03_F",[-3.7251,3.02881,-1.02176],-135.649],["Land_LuggageHeap_01_F",[-2.60767,1.95166,-1.02176],-105.495],["Land_LuggageHeap_02_F",[-1.03833,1.01074,-1.02176],-86.1553],["Land_Basket_F",[-0.921875,4.1167,-1.02176],171.864],["Land_Basket_F",[0.43457,4.15283,-1.02176],141.864],["Land_CratesShabby_F",[1.99365,4.59863,-1.02176],90.4019],["Land_Sack_F",[-3.61609,4.36523,-1.02176],158.864]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};			

			case "Land_House_2B02_F":
				{
				_templates = [[["Land_WoodenBed_01_F",[-3.38794,2.5415,-5.53068],-92.1931],["Land_WoodenBed_01_F",[-3.45776,0.599121,-5.53067],-92.1931],["Land_Sofa_01_F",[-7.26636,-1.62598,-5.53069],-2.2368],["Land_Sofa_01_F",[-8.62476,1.97949,-5.53068],-96.0528],["Land_TableBig_01_F",[-5.26782,6.26904,-5.53068],182.038],["Land_Rug_01_F",[-6.97827,3.02246,-5.53068],182.038],["Land_ChairWood_F",[-5.7644,5.27539,-5.53068],171.805],["Land_ChairWood_F",[-6.91724,6.16504,-5.53068],136.33],["Land_ChairWood_F",[-3.09058,5.79688,-5.53068],-117.417],["Land_WoodenCounter_01_F",[8.37769,0.117188,-5.53068],91.8429],["Land_WoodenCounter_01_F",[8.66821,3.07617,-5.53068],92.4286],["Land_TableDesk_F",[8.23047,6.57129,-5.53068],179.843],["Land_OfficeCabinet_01_F",[6.49683,6.88281,-5.53068],-0.448257],["Land_OfficeChair_01_F",[7.52612,5.06738,-5.53068],44.5517],["Land_Metal_rack_Tall_F",[2.5166,2.45703,-5.53068],-94.5359],["Land_Metal_rack_Tall_F",[2.75635,1.146,-5.53067],-94.5359],["Land_ShelvesWooden_F",[2.90088,6.66895,-5.53068],-97.2034],["Fridge_01_closed_F",[3.78369,6.76855,-5.53068],-1.00778],["Land_Sack_F",[5.0105,6.44043,-5.53068],-1.00778],["Land_Sack_F",[6.75635,3.0332,-5.53068],145.265],["Land_Sacks_goods_F",[6.71265,1.65088,-5.53068],126.521],["Land_BarrelWater_F",[1.27026,7.73779,-6.16978],213.633],["Land_BarrelWater_F",[-1.10229,7.76758,-6.21246],27.3254],["Land_PlasticCase_01_large_F",[0.955078,1.66992,-5.53067],178.421],["Land_Suitcase_F",[-0.50415,0.73291,-5.53067],112.046]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_House_2B03_F":
				{
				_templates = [[["Land_Sacks_goods_F",[1.43701,0.917969,-2.21301],68.2154],["Land_Sacks_heap_F",[-1.05713,1.71143,-2.21301],-13.5157],["Land_Sacks_heap_F",[-1.45996,4.79614,-2.21234],-84.6492],["Land_LuggageHeap_03_F",[1.75586,-2.30029,-2.21301],-180.357],["Land_LuggageHeap_01_F",[1.62109,-4.08252,-2.19833],130.931],["Land_LuggageHeap_02_F",[1.83789,-5.49268,-2.21301],109.876],["Land_WoodenBed_01_F",[-0.288086,-6.41284,-2.21301],-176.736],["Land_Sofa_01_F",[-3.45996,2.98804,-5.46861],-90.8525],["Land_ArmChair_01_F",[2.59082,0.0788574,-5.46861],43.8841],["Land_WoodenTable_small_F",[2.45605,4.90894,-5.46861],92.8886]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_House_2B04_F":
				{
				_templates = [[["Land_Rug_01_Traditional_F",[-3.7002,4.21826,-5.73926],85.1561],["Land_CampingTable_F",[-3.7002,4.21826,-5.73926],85.1561],["Land_TableSmall_01_F",[-5.4613,6.97314,-5.73911],0.87706],["Land_ChairPlastic_F",[-1.185,6.93896,-5.73876],-126.076],["Land_CampingChair_V2_F",[-4.60504,4.04004,-5.73888],89.4769],["Land_LuggageHeap_01_F",[-5.29608,3.0166,-5.73913],108.792],["Land_LuggageHeap_02_F",[-2.52313,7.01416,-5.73911],-65.0534],["Fridge_01_closed_F",[0.395325,2.89746,-5.73925],88.7141],["Land_Basket_F",[1.83484,2.64746,-5.73925],131.564],["Land_CratesShabby_F",[3.42316,2.87695,-5.73939],170.762],["Land_Sacks_goods_F",[3.25293,6.7251,-5.73905],-101.735],["Land_BarrelWater_F",[7.75488,-1.84473,-5.74132],143.276],["Land_BarrelWater_F",[7.06042,-2.00537,-5.74132],122.749],["Land_PlasticCase_01_large_F",[7.87433,2.41064,-5.74125],4.51776],["Land_CanisterPlastic_F",[7.71161,7.04736,-5.73931],-5.18756],["Land_GasTank_01_blue_F",[7.73883,6.4043,-5.73954],-11.1524],["Land_Sleeping_bag_blue_folded_F",[7.57318,5.71338,-5.73971],-16.5562],["Land_Sleeping_bag_blue_folded_F",[-3.78522,7.00732,-5.73889],65.0859],["Land_Sleeping_bag_brown_F",[-4.24847,5.83105,-5.73889],101.937]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_House_2W01_F":
				{
				_templates = [[["Land_Rug_01_Traditional_F",[5.74707,0.587891,-3.30696],182.834],["Land_RattanChair_01_F",[4.84766,-0.788086,-3.29671],151.81],["Land_RattanChair_01_F",[4.97461,2.31055,-3.16374],31.3861],["Land_RattanChair_01_F",[6.81445,2.43726,-3.16112],-23.4984],["Land_ChairPlastic_F",[6.64941,-0.333984,-3.15376],2.06277],["Land_WoodenBed_01_F",[-5.54395,0.412109,-3.15384],-0.937225],["Land_ArmChair_01_F",[-6.20898,-2.57593,-3.29294],296.569],["Land_CanisterPlastic_F",[-3.82227,2.61304,0.0947571],144.612],["Land_CanisterPlastic_F",[-2.97656,2.33325,0.0830383],88.8764],["Land_GasTank_01_blue_F",[-1.72852,2.84155,0.0613098],65.5996],["Land_GasTank_01_blue_F",[-0.40332,2.72266,0.0409698],48.7094],["Land_CanisterFuel_F",[0.0195313,2.52124,0.0673218],71.1506],["Land_CanisterFuel_F",[0.219727,2.24976,0.0566559],61.4775],["Land_BarrelWater_F",[-3.86914,-2.08911,-0.0549774],285.994],["Land_Sacks_heap_F",[-0.980469,-2.36182,-0.0102692],9.57745],["Land_Metal_rack_Tall_F",[1.19531,3.48145,-3.16319],0.559448],["Land_TablePlastic_01_F",[0.789063,1.72266,-3.16292],0.122498],["Land_Rug_01_Traditional_F",[1.19336,1.02466,-3.1629],0.122498],["Land_CampingChair_V2_F",[-1.15234,1.39258,-3.19357],33.122]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			case "Land_House_2W02_F":
				{
				_templates = [[["Land_Sofa_01_F",[3.71143,1.7207,-4.04601],-179.663],["Land_Rug_01_Traditional_F",[4.21826,-1.27148,-4.04601],86.617],["Land_ArmChair_01_F",[5.76025,-3.3667,-4.04601],54.1133],["Land_ArmChair_01_F",[5.9248,1.2583,-4.04601],155.209],["Land_TableSmall_01_F",[3.79688,-1.36279,-4.04601],89.2305],["Land_OfficeChair_01_F",[0.827148,-3.41992,-4.04601],132.189],["OfficeTable_01_new_F",[8.57764,2.27344,-1.29372],-85.8256],["Land_OfficeChair_01_F",[7.60547,2.78271,-1.29372],-25.8257],["Land_OfficeCabinet_01_F",[8.68311,3.92529,-1.29372],-92.2887],["Land_WoodenBed_01_F",[7.77979,-1.04785,-1.29372],-90.8553],["Land_WoodenBed_01_F",[2.43311,-1.96826,-1.29372],-178.913]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};				
				
			case "Land_House_2W03_F":
				{
				_templates = [[["Land_GasTank_01_blue_F",[-8.5376,-0.447021,-0.777275],34.357],["Land_GasTank_01_blue_F",[-8.64502,0.371094,-0.777275],-4.45886],["Land_CanisterPlastic_F",[-6.2085,4.23364,-0.777275],251.248],["Land_CanisterPlastic_F",[-6.71875,4.33521,-0.777275],266.199],["Land_CanisterPlastic_F",[-7.70459,4.39844,-0.777275],266.199],["Land_CanisterFuel_F",[-8.45605,3.65015,-0.777275],293.79],["Land_CanisterFuel_F",[-7.11572,2.80127,-0.777275],244.927],["Land_PlasticCase_01_small_F",[-6.33203,2.14746,-0.777275],215.372],["Land_PlasticCase_01_large_F",[-3.96289,-0.357422,-0.777275],267.289],["Land_Sleeping_bag_F",[-7.59961,1.25098,-0.777275],74.9884],["Land_Sleeping_bag_F",[-7.48389,0.290527,-0.777275],178.537],["Land_ArmChair_01_F",[-2.22119,6.30493,-0.777267],185.799],["Land_ArmChair_01_F",[-1.18799,6.31177,-0.777267],182.768],["Land_Rug_01_F",[-2.44092,1.69556,-5.55786],180.536],["Land_FMradio_F",[-2.79541,3.34277,-5.55786],227.081],["Land_Sacks_goods_F",[-2.06006,2.22559,-5.55786],188.176]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_House_2W04_F":
				{
				_templates = [[["Land_Sleeping_bag_brown_F",[5.98193,2.16455,-0.823494],-258.554],["Land_Sleeping_bag_blue_folded_F",[4.83691,3.15723,-0.823494],-245.566],["Land_Sleeping_bag_blue_F",[7.07764,5.94043,-0.823494],-12.1232],["Land_Ground_sheet_folded_F",[7.40869,4.51855,-0.823494],-52.3754],["Land_Ground_sheet_F",[6.57275,3.32031,-0.823494],-88.7255],["Land_FMradio_F",[7.38354,1.65137,-0.823494],-121.614],["Land_WoodenBed_01_F",[1.42139,0.889648,-0.823494],-179.258],["Land_Sofa_01_F",[3.39502,2.84766,-0.823494],-271.201],["Land_LuggageHeap_03_F",[4.83252,3.96191,-0.823494],-17.6979],["Land_LuggageHeap_01_F",[3.38232,0.530273,-0.823494],31.6532],["Land_CratesShabby_F",[-4.15967,3.13086,-5.19418],-193.446]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_House_2W05_F":
				{
				_templates = [[["Land_Sofa_01_F",[-5.42261,-1.71338,-3.32794],-268.928],["Land_ArmChair_01_F",[-6.2522,-0.0725098,-3.32794],-200.177],["Land_WoodenBed_01_F",[2.17896,-4.0625,-3.32794],-89.7854],["Land_TableSmall_01_F",[3.05811,-1.7771,-3.32794],-16.8347],["Land_TableBig_01_F",[-2.23853,0.0302734,-3.32794],-270.159],["Land_Rug_01_F",[-3.52515,-3.2439,-3.32794],-83.9022],["Land_Rug_01_F",[-5.58936,-1.19312,-0.61496],-174.863],["Land_TableBig_01_F",[-5.15454,-3.52368,-0.61496],-90.8565],["Land_RattanChair_01_F",[-5.98193,-3.98706,-0.61496],-283.391],["Land_RattanChair_01_F",[-5.06494,-1.7749,-0.61496],-308.479],["Land_Metal_rack_F",[-6.93042,1.03906,-0.61496],2.89798],["Land_ChairWood_F",[-6.53198,-2.51807,-0.61496],-125.118],["Land_LuggageHeap_01_F",[-1.82324,-4.33301,-0.61496],-56.6602],["Land_LuggageHeap_02_F",[-1.9834,-3.50146,-0.61496],-56.6602],["Land_Basket_F",[-2.9873,-4.36548,-0.61496],-87.2847],["Land_Sack_F",[-3.93359,-4.41406,-0.61496],-117.158]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};				

			case "Land_House_1W01_F":
				{
				_templates = [[["Land_Rug_01_Traditional_F",[1.93311,2.28467,-2.84728],-91.466],["Land_TableBig_01_F",[1.34912,2.24512,-2.84728],-1.05022],["Land_TableSmall_01_F",[4.44922,0.491211,-2.84728],-178.228],["Land_ChairWood_F",[1.92334,3.24609,-2.84728],48.3329],["Land_ChairWood_F",[2.77393,2.14673,-2.84728],-105.425],["Land_ChairWood_F",[4.0918,4.56836,-2.84728],-111.207],["Land_OfficeCabinet_01_F",[-4.1792,0.131836,-2.84728],-180.157],["Land_OfficeChair_01_F",[-4.10986,2.00073,-2.84728],29.1538],["Land_RattanChair_01_F",[-3.27783,4.82275,-2.84728],-83.5402],["Land_Suitcase_F",[-2.29199,4.78735,-2.84728],-134.82],["Land_PlasticCase_01_small_F",[-2.43848,3.79663,-2.84728],-160.308]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_House_1W02_F":
				{
				_templates = [[["Land_Rug_01_F",[-2.3999,1.04663,-2.12372],-2.35187],["Land_TablePlastic_01_F",[-3.12061,1.0835,-2.12371],-92.3519],["Land_RattanChair_01_F",[-3.30127,-0.695068,-2.12376],26.2736],["Land_TableDesk_F",[4.25244,2.9812,-2.12385],-176.164],["Land_OfficeCabinet_01_F",[3.41357,1.0769,-2.12385],85.53],["Land_OfficeChair_01_F",[4.36377,1.96973,-2.12385],-214.47],["Land_Metal_rack_Tall_F",[-0.266113,3.36743,-2.12381],1.14503],["Fridge_01_closed_F",[0.58252,2.55444,-2.12378],-77.3222],["Land_LuggageHeap_03_F",[0.504883,1.04492,-2.12376],-75.3962]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_House_1W03_F":
				{
				_templates = [[["Land_ArmChair_01_F",[-2.6792,3.25684,-2.32535],-143.13],["Land_WoodenBed_01_F",[-0.976563,1.37305,-2.32535],-91.7275],["Land_Sofa_01_F",[-3.30811,1.10059,-2.32535],-94.9716],["Land_TableBig_01_F",[-1.43506,-5.59521,-2.32535],-177.929],["Land_TableSmall_01_F",[-1.12988,-1.44775,-2.32535],-269.239],["Land_Rug_01_F",[-1.46289,-5.87402,-2.32535],-179.486],["Land_RattanChair_01_F",[-1.55713,-6.41699,-2.32535],-173.067],["Land_RattanChair_01_F",[0.118652,-5.4668,-2.32536],-80.6107],["Land_ShelvesWooden_F",[1.61963,-7.67871,-2.32536],0.303616],["Fridge_01_closed_F",[-2.62305,-7.85889,-2.32535],-179.888],["Land_Basket_F",[1.01221,-3.29004,-2.32535],-84.3414],["Land_CratesShabby_F",[1.94434,-3.75537,-2.32536],-91.469]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_House_1W04_F":
				{
				_templates = [[["Land_WoodenBed_01_F",[-0.536133,4,-2.49545],-261.98],["Land_Sofa_01_F",[-4.23926,-4.14355,-2.54521],-86.056],["Land_Sofa_01_F",[-3.08594,-1.21777,-2.54508],-176.981],["Land_TableSmall_01_F",[-2.93945,-2.28662,-2.54198],-81.2299],["Land_TableBig_01_F",[-1.46484,-4.07568,-2.54826],-90.0731],["Land_Rug_01_F",[-0.387695,-2.95557,-2.53169],1.12569],["Land_Rug_01_F",[-0.432617,1.93994,-2.50297],-178.477],["Land_RattanChair_01_F",[-0.793945,-3.55322,-2.53912],-35.363],["Land_RattanChair_01_F",[-2.64453,-4.00195,-2.54607],-310.49],["OfficeTable_01_old_F",[0.62793,-1.63379,-2.54688],-91.2174]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];	
				};	

			case "Land_House_1W05_F":
				{
				_templates = [[["Land_Sack_F",[4.68774,-1.66504,-0.827644],141.295],["Land_CratesShabby_F",[4.97681,-0.348633,-0.827644],176.376],["Land_Basket_F",[3.14648,-1.90771,-0.827644],134.512],["Land_LuggageHeap_02_F",[2.03589,-1.89014,-0.827648],72.7352],["Land_CampingChair_V2_F",[4.59985,1.5791,-0.827648],212.389],["Land_CampingChair_V1_F",[3.6145,1.85156,-0.827648],166.514],["Land_Sofa_01_F",[-0.83374,1.31982,-0.827648],175.435],["Land_ArmChair_01_F",[-1.39453,-1.77148,-0.827648],8.58655],["Land_Sleeping_bag_brown_F",[-0.238037,-0.823242,-0.827648],8.58655],["Land_WoodenTable_small_F",[1.44849,0.425781,-0.827644],-2.25555],["Land_Rug_01_Traditional_F",[2.48682,1.22705,-0.827648],175.978]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};				

			case "Land_House_1W06_F":
				{
				_templates = [[["Land_Rug_01_F",[2.4248,-0.77832,-0.617859],96.9872],["Land_ArmChair_01_F",[4.04443,-1.20874,-0.617859],149.033],["Land_ArmChair_01_F",[2.40381,-1.86914,-0.617859],213.98],["Land_Sofa_01_F",[3.25781,1.42065,-0.617859],179.077],["Land_Sacks_goods_F",[-0.775391,-1.03662,-0.617859],0.554688],["Land_Sack_F",[-2.01563,1.88892,-0.617859],-66.7648],["Land_CratesShabby_F",[-0.343262,1.71069,-0.617859],90.0985]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_House_1W07_F":
				{
				_templates = [[["Land_Metal_rack_F",[4.5105,3.46387,-3.0888],0.752747],["Land_Metal_rack_Tall_F",[6.58765,1.1582,-3.0888],-88.8517],["Fridge_01_closed_F",[5.66382,3.20752,-3.0888],-2.58733],["OfficeTable_01_old_F",[1.68726,1.37646,-3.0888],89.7791],["Land_OfficeChair_01_F",[2.83936,0.960449,-3.0888],-120.221],["Land_ChairWood_F",[6.23584,-2.65381,-3.0888],-14.5836],["Land_WoodenTable_large_F",[4.68237,0.993652,-3.0888],-179.277],["Land_Rug_01_F",[-2.80347,-5.5835,-3.0888],-74.3024],["Land_Rug_01_Traditional_F",[-3.21655,-1.41602,-3.0888],169.065],["Land_TableBig_01_F",[-5.27832,-2.90283,-3.0888],-1.24489],["Land_TableSmall_01_F",[-5.12988,-7.54395,-3.0888],-91.9739],["Land_Sofa_01_F",[-2.03467,0.980957,-3.0888],169.099],["Land_ArmChair_01_F",[-6.68677,-0.986816,-3.0888],-101.989],["Land_WoodenBed_01_F",[-4.54614,-4.79395,-3.0888],88.5272],["Land_Sleeping_bag_blue_folded_F",[0.312988,-7.48193,-3.0888],-139.97],["Land_Sleeping_bag_blue_F",[-1.45166,-6.59961,-3.0888],-139.97],["Land_PlasticCase_01_small_F",[-3.29419,-7.56982,-3.0888],-77.5297],["Land_LuggageHeap_02_F",[0.40918,-6.50635,-3.0888],-18.794],["Land_LuggageHeap_01_F",[0.637207,3.12744,-3.0888],49.0527],["Land_ShelvesWooden_F",[-2.29126,3.30078,-3.0888],87.1247]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};		

			case "Land_House_1W08_F":
				{
				_templates = [[["Land_Basket_F",[0.813477,-1.40112,-1.87781],171.763],["Land_Sack_F",[1.00684,-0.282959,-1.87781],175.551],["Land_Sacks_goods_F",[-1.05566,-0.879395,-1.87782],148.365],["Land_ArmChair_01_F",[-1.16602,3.38696,-1.87782],82.2936],["Land_TableSmall_01_F",[-0.649414,2.50464,-1.87782],86.398],["Land_TableBig_01_F",[3.14063,3.72681,-1.87782],-1.3183],["Land_Rug_01_Traditional_F",[2.19824,1.92969,-1.87782],267.96],["Land_RattanChair_01_F",[3.59668,2.89893,-1.87782],238.685],["Land_RattanChair_01_F",[1.32617,3.50269,-1.87782],112.721],["Land_LuggageHeap_03_F",[5.67383,3.18091,-1.87784],179.762],["Fridge_01_closed_F",[-4.79395,3.65234,-1.89088],3.02002]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_House_1W09_F":
				{
				_templates = [[["Land_WoodenTable_small_F",[-5.39551,1.52783,-1.95306],-94.7216],["Land_WoodenBed_01_F",[-3.44775,3.24854,-1.95307],-0.180527],["Land_Rug_01_F",[-3.09668,1.90723,-1.95306],-270.163],["Land_RattanChair_01_F",[-1.63281,3.55957,-1.95306],-38.8891],["Land_TableBig_01_F",[-6.28564,-1.89063,-1.95306],-87.2562],["Land_Rug_01_Traditional_F",[-2.92896,-1.96191,-1.95306],-88.8655],["Land_RattanChair_01_F",[-6.28345,-3.67334,-1.95306],-166.706],["Land_RattanChair_01_F",[-5.66528,-1.57715,-1.95306],-98.4321],["Land_OfficeCabinet_01_F",[-4.20825,-0.433105,-1.95306],-0.75602],["Land_OfficeChair_01_F",[-2.2627,-3.46289,-1.95306],-277.531],["OfficeTable_01_new_F",[-0.609863,-3.01807,-1.95306],-90.659]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_House_1W10_F":
				{
				_templates = [[["Land_Rug_01_Traditional_F",[-2.78357,-2.43457,-1.4537],-93.1617],["Land_ArmChair_01_F",[-3.3717,-2.50537,-1.4537],-59.5439],["Land_ArmChair_01_F",[-1.88074,-2.11035,-1.4537],15.4561],["Land_TableSmall_01_F",[-4.20471,-1.14893,-1.4537],-167.636],["Land_TableBig_01_F",[1.27319,-3.37354,-1.4537],-0.620613],["Land_Rug_01_F",[0.998901,-2.22949,-1.4537],-0.620613],["Land_CanisterPlastic_F",[-0.86731,-3.875,-1.4537],-49.8171],["Land_ShelvesWooden_F",[-1.75183,-3.64111,-1.4537],-90.0548],["Land_RattanChair_01_F",[1.65149,-2.44775,-1.4537],-321.318],["Land_RattanChair_01_F",[0.660522,-2.73145,-1.4537],8.97219]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_House_1W11_F":
				{
				_templates = [[["Land_Rug_01_Traditional_F",[-6.37256,-0.930664,-2.8218],-181.442],["Land_TableSmall_01_F",[-5.43311,-2.21191,-2.8218],-180.377],["Land_ArmChair_01_F",[-5.6748,-0.931152,-2.8218],-257.554],["Land_ArmChair_01_F",[-6.79102,-5.19385,-2.8218],-2.08177],["Land_WoodenBed_01_F",[2.18115,-1.5625,-2.63606],2.09751],["Land_TableBig_01_F",[-0.260742,-5.4165,-2.63606],2.64241],["Land_PlasticCase_01_small_F",[2.646,-3.45703,-2.63606],-0.250397],["Land_BarrelWater_F",[2.81543,-5.7583,-2.63606],-41.6011],["Land_Sacks_heap_F",[1.72314,-5.60156,-2.63606],-66.027],["Land_Basket_F",[-3.5249,-1.02734,-2.63024],-192.815],["Land_LuggageHeap_02_F",[0.488281,-0.742676,-2.63606],-292.702],["Land_ShelvesWooden_F",[-0.439941,1.66699,-2.63606],-271.466],["Land_ChairWood_F",[-0.124512,-4.16846,-2.63606],-68.1566],["Land_ChairWood_F",[-2.08496,-4.97461,-2.63024],-301.175],["Land_CanisterPlastic_F",[-3.61133,-2.16357,-2.63024],-88.1609],["Land_CanisterPlastic_F",[-3.96094,-2.83691,-2.63606],-148.497]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};	

			case "Land_House_1W12_F":
				{
				_templates = [[["Land_Metal_rack_F",[4.38281,-5.60059,-2.51156],-86.6244],["OfficeTable_01_new_F",[4.20654,-7.61719,-2.51156],-90.3103],["Land_OfficeChair_01_F",[3.1084,-7.52344,-2.51156],29.6897],["Land_TableDesk_F",[0.451172,-8.17725,-2.51156],0.373642],["Land_OfficeCabinet_01_F",[-0.499512,-6.21729,-2.51156],95.5072],["Land_RattanChair_01_F",[2.60791,-4.83545,-2.51156],-131.749],["Land_WoodenTable_small_F",[2.58496,-6.30664,-2.51156],-180.415],["Land_Rug_01_F",[1.7749,-6.39746,-2.51156],-174.756],["Land_Rug_01_Traditional_F",[5.38086,-1.80176,-2.51156],3.55893],["Land_TableBig_01_F",[5.38086,-1.80176,-2.51156],3.55893],["Land_Sofa_01_F",[7.53809,-2.56396,-2.51156],86.3833],["Land_RattanChair_01_F",[5.0625,-0.935547,-2.51156],-29.6597],["Land_ChairPlastic_F",[5.604,1.62402,-2.51156],-7.60976],["Land_TableSmall_01_F",[7.73633,2.42627,-2.51156],-182.102],["Land_PlasticCase_01_small_F",[7.78125,1.31299,-2.51156],-181.519],["Land_Sack_F",[5.97217,3.12158,-2.51156],-113.784]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};				

			case "Land_House_1B01_F":
				{
				_templates = [[["Land_Sack_F",[3.59521,5.59192,-2.80689],30.2534],["Land_Sack_F",[3.5918,4.73523,-2.80663],75.2534],["Land_Sacks_goods_F",[2.27051,5.56274,-2.80663],-104.604],["Land_Sacks_heap_F",[2.55908,4.04816,-2.80689],-176.826],["Land_BarrelWater_F",[-2.19336,5.77313,-2.80689],-56.8458],["Land_PlasticCase_01_large_F",[2.82861,9.92322,-2.80663],0.63652],["Land_PlasticCase_01_small_F",[1.06689,10.698,-2.80663],87.8135],["Land_GasTank_01_blue_F",[-2.27295,6.76917,-2.80663],-187.247],["Land_CanisterPlastic_F",[-2.26855,7.3078,-2.80663],-201.901],["Land_CanisterFuel_F",[-2.62988,10.8017,-2.80663],-250.988],["Land_Pillow_old_F",[-1.4585,9.81152,-2.80663],-250.988],["Land_Sleeping_bag_F",[-0.686523,8.8092,-2.80663],-226.039],["Land_Sleeping_bag_blue_F",[1.56152,8.75024,-2.80677],-190.976],["Land_Sleeping_bag_blue_folded_F",[0.237793,8.46912,-2.80667],-156.486],["Land_Ground_sheet_folded_blue_F",[-1.2417,8.9834,-2.80663],-137.401],["Land_FMradio_F",[-0.290527,10.8643,-2.80663],-173.085],["Land_CampingTable_small_F",[-2.22803,8.80957,-2.77663],-98.1159],["Land_CampingChair_V1_F",[-2.31104,10.0458,-2.77664],0.798355],["Land_TableDesk_F",[0.967773,0.863525,-2.80663],-179.39],["Land_OfficeCabinet_01_F",[2.41064,-1.30762,-2.80663],-92.5229],["Land_OfficeChair_01_F",[1.39307,-0.386902,-2.80663],-130.694],["Land_LuggageHeap_03_F",[-0.617188,9.88452,-2.80663],-77.8624],["Land_Sofa_01_F",[7.08398,-4.35394,-2.80663],84.6399],["Land_TableBig_01_F",[0.606934,-2.87817,-2.80663],-90.7994],["Land_Rug_01_Traditional_F",[0.606934,-2.87817,-2.80663],-90.7994],["Land_ChairWood_F",[1.8667,-2.92883,-2.80663],-103.343],["Land_ChairWood_F",[-0.398926,-3.10193,-2.80663],25.0441]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};

			case "Land_Camp_House_01_brown_F":
				{
				_templates = [[["Land_Rug_01_F",[-2.05811,4.90186,-1.40231],-3.26447],["Land_Rug_01_Traditional_F",[0.708008,4.89526,-1.40231],-3.31885],["Land_CampingTable_F",[2.4917,3.09912,-1.40231],269.729],["Land_CampingChair_V2_F",[-2.80713,5.09302,-1.40231],172.973],["Land_CampingChair_V1_F",[2.2334,4.74316,-1.40231],2.12903],["Land_CampingChair_V1_F",[1.61768,3.23926,-1.40231],78.1324],["Land_LuggageHeap_03_F",[2.41943,5.99805,-1.40231],122.822],["Land_Basket_F",[-2.37744,2.27026,-1.40231],260.245],["Land_Sack_F",[-2.23438,3.09863,-1.40231],245.245],["Land_BarrelWater_F",[-2.75049,3.90845,-1.40231],227.273],["Land_BarrelWater_F",[0.283203,6.06445,-1.40231],142.188],["Land_PlasticCase_01_large_F",[-0.95459,6.19434,-1.40231],90.7318]]];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
				
			/*	
			case "":
				{
				_templates = [];
				_items = _templates select floor random count _templates;  
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_furniture",_items];
				};
			*/		
			
			default
				{
				_bld setvariable ["tpw_furnished",-1]; // non furnishable houses will subsequently be ignored
				};
						
			};
		};
		
	// Furnish house  if list is assigned and no people inside
	if (_bld getvariable "tpw_furnished" == 1 && {!(isobjecthidden _bld)} && {count (_bld nearEntities ["Man", 7]) == 0}) then
		{
		_items = _bld getvariable ["tpw_furniture",[]];
		_bld setvariable ["tpw_furnished",2];
		_dir = getdir _bld;
		_spawned = [];
			{
			if (random 1 > 0.25) then
				{
				_item = _x select 0;
				_offset = _x select 1;
				_angle = _x select 2;
				_dir = getdir _bld;
				_pos = _bld modeltoworld _offset;
				_item =  createsimpleobject [_item,[0,0,0]];
				_item setposatl _pos;
				_item setdir (_dir - _angle);
				_spawned pushback _item;
				sleep 0.1;	// allow time for object to settle properly, and space out spawning to reduce cpu spike 		
				_item enablesimulation false;
				};
			} count _items;
		_bld setvariable ["tpw_spawned",_spawned]; // array of spawned furniture for this house, for subsequent removal
		tpw_furniture_houses pushback _bld;	
		};
	};

// MAIN LOOP
sleep 10;
private ["_blds","_item","_bld"];
while {true} do
	{
	// Scan for houses to furnish
	if (tpw_furniture_active && {player == vehicle player} && {player  distance tpw_furniture_lastpos > (tpw_furniture_radius / 2) }) then
		{		
		tpw_furniture_lastpos = position player;
		_blds = player nearObjects ["House",tpw_furniture_radius];
			{
			0 = [_x] spawn tpw_furniture_fnc_populate;
			} count _blds;
		
		// Delete furniture from distant houses 
		for "_i" from 0 to count tpw_furniture_houses - 1 do
			{
			_bld = tpw_furniture_houses select _i;
			if (_bld distance player > tpw_furniture_radius) then
				{
					{
					deletevehicle _x;
					sleep 0.05;
					} count (_bld getvariable "tpw_spawned");
				_bld setvariable ["tpw_furnished",1];
				_bld setvariable ["tpw_spawned",[]];				
				tpw_furniture_houses set [_i,-1];	
				};
			};
		tpw_furniture_houses = tpw_furniture_houses - [-1];
		};	
	sleep tpw_furniture_scantime;
	};