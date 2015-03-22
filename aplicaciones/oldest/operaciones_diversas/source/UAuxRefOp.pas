unit UAuxRefOp;

interface

  function getDayOfTheYear( fromDate: TDateTime ): word;
  function getReferenciaOperacion( fromFecha: TDateTime; numReferencia: Integer ): String;
  function testReferenciaOperacion(const Referencia: String): Boolean;

implementation

  uses
    SysUtils,
    rxStrUtils;

  function getDayOfTheYear( fromDate: TDateTime ): word ;
  const
    diasAcumMeses: array [boolean] of array [1..12] of integer =
      ( ( 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 ),
        ( 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335 ) );
  var
    anno,
    mes,
    dia: word;
  begin
    DecodeDate( fromDate, anno, mes, dia );
    result := diasAcumMeses[ isLeapYear( anno ) ][ mes ] + dia;
  end;

  function getReferenciaOperacion( fromFecha: TDateTime; numReferencia: Integer ): String;
  var
    auxNumero: Int64;
  begin
    Result := '2052' + formatDateTime('yyyy',fromFecha)[4] + AddChar( '0', intToStr(getDayOfTheYear(fromFecha)), 3 );
    Result := Result + '0' + AddChar( '0', intToStr( numReferencia ), 6 );
    // hasta el momento tenemos un número de 16 dígitos. Hay que calcular el módulo 7
    auxNumero := strToInt64( Result );
    Result := Result + Trim( intToStr( auxNumero mod 7 ) );
  end;

  function testReferenciaOperacion(const Referencia:String): Boolean;
  var
    auxNumero: Int64;
    auxdc: Integer;
    auxString: String;
  begin
    auxString := Trim(Referencia);
    auxNumero := strToInt64(Copy(auxString, 1, 15));
    auxDC     := strToInt(Copy(auxString, 16, 1));
    Result    := (auxNumero mod 7) = auxDC;
  end;

end.
