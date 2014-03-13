var clouddb = { 

	key: null,
	db: '',
	debug: false,
	remote: '',
	opts : { continuous: false },

	init : function(dbname) {
		this.db = new PouchDB(dbname);
		this.opts = { continuous: false };
		this.remote = 'https://darrengates:Mu$ic123@darrengates.cloudant.com/' + dbname;
		this.debug = true;
		this.key = null;
	},

	/* update existing doc, or create new if does not exist */
	saveData : function(docname, data) {
		var thedb = this.db;
	
		this.db.get(docname, function(err, resp) {
				
			if ( err ) {			
				/* add new data */
				console.log("creating new data");
				thedb.put({
					_id: docname,
					data: data
				}, function callback(err, result) {
					console.log(err || result);
				});
			}
			else {
				/* update existing data */
				console.log("updating existing data");
				thedb.put({
					_id: docname,
					_rev: resp._rev,
					data: data
				}, function callback(err, result) {
					console.log(err || result);
				});
			}
		});

	},

	getData : function(id) {
		return this.db.get(id, function(err, doc) {
			console.log(err || doc);
		});
	},

	showAllDocs : function() {
		this.db.allDocs({include_docs: true, descending: true}, function(err, doc) {
			console.log(doc.rows);
		});
	}

	/*
	if ( !debug ) {
		db.replicate.to(remote, opts);
		db.replicate.from(remote, opts);
	}
	*/
}
