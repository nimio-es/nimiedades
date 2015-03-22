unit UAuxClaveAut;

interface

  function isANumber(const aNumString: String): Boolean;
  function testClaveAutoriza(const aKey: String): Boolean;
  function getClaveAutErrorMsg: String;

implementation

  uses
    SysUtils,
    rxStrUtils;

  var
    theErrorMsg: String;

  function isANumber(const aNumString: String): Boolean;
  var
    iPos,
    lenStr: Integer;
  begin
    Result := TRUE;
    lenStr := length(aNumString);
    iPos   := 1;
    while ((iPos <= lenStr) and Result) do
    begin
      if (aNumString[iPos] < '0') or (aNumString[iPos] > '9') then
        Result := FALSE;
      inc(iPos);
    end;
  end;

  function testEntOficDC(const aEntOfic, aDigCont: String): Boolean;
  const
    kPesos: array [1..8] of integer =
       ( 4,8,5,10,9,7,3,6 );
  var
    theEntOfic: String;
    iPos,
    digCont: Integer;
    sumaPesos: int64;
  begin
    theEntOfic := AddCharR('0', Trim(aEntOfic), 8);
    sumaPesos  := 0;
    for iPos := 1 to 8 do
      sumaPesos := sumaPesos + (strToInt(theEntOfic[iPos]) * kPesos[iPos]);

    digCont := 11- (sumaPesos mod 11);
    if digCont = 10 then digCont := 1;
    if digCont = 11 then digCont := 0;

    Result := (digCont = StrToInt(AddChar('0',Trim( aDigCont), 1)))
  end;

  function testClaveAutoriza(const aKey: String): Boolean;
  var
    theKey: String;
    numKey: Int64;
    resto,
    digCont: Integer;
  begin
    Result := FALSE;
    theKey := AddCharR('0', Trim(aKey), 18);
    if not isANumber(theKey) then
      theErrorMsg := 'La clave no es numérica.'
    else
    begin
      // se prueba que el dígito de la Entidad-Oficina es correcto
      if not testEntOficDC(Copy(theKey, 4, 8), Copy(theKey, 12, 1)) then
        theErrorMsg := 'El dígito de control interno asociado a la Entidad-Oficina no es correcto.'
      else
      begin
        numKey  := StrToInt64(Copy(theKey, 1, 17));
        digCont := strToInt(Copy(theKey, 18, 1));
        resto := numKey mod 7;
        if resto <> digCont then
          theErrorMsg := 'La Clave de Autorización no es válida.'
        else
          Result := TRUE;
      end
    end;
  end;

  function getClaveAutErrorMsg: String;
  begin
    Result := theErrorMsg;
  end;

end.

