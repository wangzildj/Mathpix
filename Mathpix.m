$MathpixToken = {"ID", "Key"} -> {
	"trial",
	"34f1a4cea0eaca8540c95908b4dc84ab"
} // AssociationThread;
MathpixHTTP[img_] := Block[
	{jpeg, url, header, body},
	jpeg = "data:image/jpg;base64," <> ExportString[img, {"Base64", "JPEG"}];
	url = "https://api.mathpix.com/v3/latex";
	header = {
		"app_id" -> $MathpixToken["ID"],
		"app_key" -> $MathpixToken["Key"],
		"Content-type" -> "application/json"
	};
	body = ExportString[{
		"src" -> jpeg, "formats" -> {"latex" -> "simplified", "mathml" -> True, "wolfram" -> True
		}}, "json"];
	HTTPRequest[url, <|"Headers" -> header, "Body" -> body, Method -> "POST"|>]
];
Mathpix[path_String, o___] := Mathpix[Import@path, o];
Mathpix[img_Image, method_ : N] := MathpixInterface[MathpixPOST@MathpixHTTP@img];
Mathpix[obj_Association, method_ : N] := MathpixInterface[First@obj];
MathpixInterface[raw_Association, m_] := Block[
	{},
	(*Todo: Sow Error*)
	Switch[m,
		N, MathpixNormal@raw,
		E, MathpixExpression@raw,
		D, MathpixDisplay@raw,
		C, MathpixConfidence[raw],
		_, Iconize[raw, "Mathpix"]
	]
];
MathpixPOST[http_HTTPRequest] := URLExecute[http, Interactive -> False, "RawJSON"];
MathpixNormal[raw_] := raw["latex"];
MathpixDisplay[raw_] := DisplayForm@ImportString@raw["mathml"];
MathpixExpression[raw_] := InputForm@WolframAlpha[raw["wolfram"], "WolframParse"];
MathpixConfidence[raw_] := "TODO";