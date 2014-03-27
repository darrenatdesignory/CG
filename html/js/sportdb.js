var sportdb = {
	/* fetch the team name from the team ID */
	getTeam : function(teamID) {
		var res = globals.lib.query("teams", {ID: teamID});
		
		return res[0];
	},
		
	/* fetch the sport name from the sport key */
	getSport : function(sportKey) {
	
	},
	
	/* fetch all player data from player ID */
	getPlayer : function(playerID) {
	
	}
}