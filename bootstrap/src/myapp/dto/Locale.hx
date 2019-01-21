package myapp.dto;

abstract Locale(String)
	from String to String {

	public var lang (get,never) : String;

	public var country (get,never) : String;

	private inline function get_lang() : String {
		return this.substr(0,2).toLowerCase();
	}

	private inline function get_country() : Null<String> {
		if (this.length <= 3) return null;
		return this.substr(3);
	}
}
