/* Coach Gizmo player position file */

"use strict;"

var data = {
	leagues : {
		football : [
			'Pop Warner',
			'Adult League',
			'College',
			'Junior High',
			'High School',
			'Professional'
		],
		soccer : [
			'AYSO',
			'Club',
			'College',
			'Junior High',
			'High School',
			'Professional'
		],
		baseball : [
			'Little League',
			'Adult League',
			'Junior High',
			'High School',
			'College',
			'Professional'
		],
		softball : [
			'Little League',
			'Adult League',
			'Junior High',
			'High School',
			'College',
			'Professional'
		],
		basketball : [
			'Youth',
			'Adult League',
			'Junior High',
			'High School',
			'College',
			'Professional'
		],
		hockey : [
			'Youth',
			'Adult League',
			'Junior High',
			'High School',
			'College',
			'Professional'
		],
		lacrosse : [
			'Youth',
			'Adult League',
			'Junior High',
			'High School',
			'College',
			'Professional'
		]
	},
	environments : {
		weather : [
			'Cloudy',
			'Light Drizzle',
			'Hail',
			'Rain',
			'Sleet',
			'Sunny'
		],
		turf : [
			'Slippery',
			'Dry',
			'Muddy'
		],
		temperature : [
			'Cold',
			'Average',
			'Hot', 
			'Sweltering'
		]
	}, 
	fields : {
		/* key : [ text, type, size ]  */
		age 		: [ 'Age', 'text', 60 ],
		fieldtype 	: [ 'Field Type', 'text', 100 ],
		logophoto 	: [ 'Logo/Photo', 'binary', 0 ],
		region 		: [ 'Region', 'text', 50 ],
		season 		: [ 'Season', 'text', 50 ],
		teamparent 	: [ 'Team Parent', 'text', 70 ]
	},
	positions : {
		football : [
			['Defence','Outside Linebacker','OLB'],
			['Defense','Middle Linebacker','MLB'],
			['Defence','Nosetackle','NT'],
			['Defence','Cornerback','CB'],
			['Defence','Safety','S'],
			['Offense','Tackle','T'],
			['Offence','Guard','T'],
			['Offence','Center','C'],
			['Offence','Quarterback','QB'],
			['Offence','Running Back','RB'],
			['Offence','Fullback','FB'],
			['Offence','Tailback','TB'],
			['Offence','Tight End','TE'],
			['Offence','Wide Receiver','WR'],
			['Special Teams','Kicker','K'],
			['Special Teams','Holder','H'],
			['Special Teams','Long Snapper','LS'],
			['Special Teams','Punter','P'],
			['Special Teams','Kickoff Specialist','KOS'],
			['Special Teams','Kick Returner','KR'],
			['Special Teams','Punt Returner','PR'],
			['Special Teams','Upback','UB'],
			['Special Teams','Gunner','G'],
			['Special Teams','Jammer','J']
		],
		soccer : [
			['','Goalie','G'],
			['Defense','Left Fullback','LF'],
			['Defense','Center Left Fullback','CLF'],
			['Defense','Center Right Fullback','CRF'],
			['Defense','Right Fullback','RF'],
			['Defense','Stopper','STP'],
			['Defense','Sweeper','SWP'],
			['Midfield','Left Mid','LM'],
			['Midfield','Center Left Mid','CLM'],
			['Midfield','Center Mid','CM'],
			['Midfield','Center Right Mid','CRM'],
			['Midfield','Right Mid','RM'],
			['Forward','Left Striker','LS'],
			['Forward','Center Left Forward','CLF'],
			['Forward','Center Forward','CF'],
			['Forward','Center Right Forward','CRF'],
			['Forward','Right Striker','RS']
		],
		baseball : [
			['Infield','Catcher','C'],
			['Pitcher','Ace Pitcher','AP'],
			['Pitcher','Starting Pitcher','SP'],
			['Pitcher','Relief Pitcher','RP'],
			['Pitcher','Middle Relief Pitcher','MRP'],
			['Pitcher','Long Relief Pitcher','LRP'],
			['Pitcher','Setup Pitcher','SP'],
			['Pitcher','Closer','C'],
			['Infield','1st Base','1B'],
			['Infield','2nd Base','2B'],
			['Infield','Short Stop','SS'],
			['Infield','3rd Base','3B'],
			['Outfield','Left Field','LF'],
			['Outfield','Center Field','CF'],
			['Outfield','Right Field','RF'],
			['Substitute','Designated Hitter','DH'],
			['Substitute','Pinch Hitter','PH'],
			['Substitute','Pinch Runner','PR']
		],
		basketball : [
			['','Point Gaurd','PG'],
			['','Shooting Gaurd','SG'],
			['','Small Forward','SF'],
			['','Power Forward','PF'],
			['','Center','C']
		],
		hockey : [
			['','Goaltender','G'],
			['Line 1','Left Defenseman','LD'],
			['Line 1','Right Defenseman','RD'],
			['Line 1','Left Winger','LW'],
			['Line 1','Center','C'],
			['Line 1','Right Winger','RW'],
			['Line 2','Left Defenseman','LD'],
			['Line 2','Right Defenseman','RD'],
			['Line 2','Left Winger','LW'],
			['Line 2','Center','C'],
			['Line 2','Right Winger','RW'],
			['Line 3','Left Defenseman','LD'],
			['Line 3','Right Defenseman','RD'],
			['Line 3','Left Winger','LW'],
			['Line 3','Center','C'],
			['Line 3','Right Winger','RW']
		],
		lacrosse : [
			['','Goalie','G'],
			['Defense','Left Defensemen','LD'],
			['Defense','Center Left Defensemen','CLD'],
			['Defense','Center Defensemen','CD'],
			['Defense','Center Right Defensemen','CRD'],
			['Defense','Right Defensemen','RD'],
			['Midfield','Left Mid','LM'],
			['Midfield','Center Left Mid','CLM'],
			['Midfield','Center Mid','CM'],
			['Midfield','Center Right Mid','CRM'],
			['Midfield','Right Mid','RM'],
			['Attack','Left Attacker','LA'],
			['Attack','Center Left Attacker','CLA'],
			['Attack','Center Attacker','CA'],
			['Attack','Center Right Attacker','CRA'],
			['Attack','Right Attacker','RA']
		]
	},
};