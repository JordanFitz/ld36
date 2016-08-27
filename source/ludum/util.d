module ludum.util;

import std.stdio: stderr;
import std.json: parseJSON, JSONValue, JSON_TYPE;
import std.file: readText, exists, isFile;
import std.algorithm: cmp;
import std.math: floor;

import dsfml.graphics;

/**
 * A utility class containing functions that are useful in multiple cases, 
 * rather than copying them a bunch of times in different classes
 */
static class Util
{
private static: 
	JSON_TYPE _convertType(string type)
	{
		switch(type)
		{
			case "null": return JSON_TYPE.NULL;
			case "string": return JSON_TYPE.STRING;
			case "int": return JSON_TYPE.INTEGER;
			case "uint": return JSON_TYPE.UINTEGER;
			case "float": return JSON_TYPE.FLOAT;
			case "object": return JSON_TYPE.OBJECT;
			case "array": return JSON_TYPE.ARRAY;

			default: assert(0, `Unrecognized JSON type "` ~ type ~ `"`);
		}
	}

public static:
	/**
	 * Attempt to load a texture and make sure it was successful
	 * Params:
	 *  source = the location of the image file
	 * Returns: The resulting sf::Texture
	 */
	Texture loadTexture(string source)
	{
		Texture texture = new Texture;

		assert(texture.loadFromFile(source), "Failed to load texture from " ~ source);

		return texture;
	}

	/**
	 * Make sure the given file exists and then parse it as JSON
	 * Params:
	 *  source = the location of the JSON file
	 * Returns: the resulting parsed JSONValue
	 */
	JSONValue loadJSON(string source)
	{
		assert(
			exists(source) && isFile(source),
			`Nonexistent JSON file "` ~ source ~ `"`
		);

		return parseJSON(readText(source));
	}

	/**
	 * Assert that the given JSONValue has the correct type
	 * Params:
	 *  value = the value that will be type-checked
	 *  type = the type that's expected
	 *  error = the error message to display upon failure
	 */
	void validateType(JSONValue value, string type, string error = null)
	{
		if(error is null)
		{
			error = "Field must be of type " ~ type;
		}

		if(cmp(type, "bool") == 0)
		{
			assert(value.type() == JSON_TYPE.TRUE || value.type() == JSON_TYPE.FALSE, error);
			return;
		}

		assert(value.type() == _convertType(type), error);
	}

	/**
	 * Make sure that the given property exists in the given JSON and check its type
	 * Params:
	 *  json = the haystack to search in
	 *  name = the needle to search with
	 *  type = the required type
	 */
	void validateField(JSONValue json, string name, string type = null)
	{
		string error = `JSON validation failed at field "` ~ name ~ `"`;

		assert(name in json, error);

		if(type is null)
		{
			return;
		}

		error ~= "\nField must be of type " ~ type;
		
		validateType(json[name], type, error);
	}

	/**
	 * Compare two strings
	 * Params:
	 *  stringA = the first string to compare
	 *  stringB = the second string to compare
	 * Returns: A boolean indicating whether or not the strings are equal
	 */
	bool compare(string stringA, string stringB)
	{
		return stringA.cmp(stringB) == 0;
	}
}