unit CPrintSopAgent;

interface

  uses
    SysUtils,
    Classes,
    Contnrs,
    rxStrUtils,
    COpDivSystemRecord,
    CSoporte;

  type

    TPrintSopAgent = class(TObject)
      protected
        FSoporte: TSoporte;

        FOpsCobros,
        FOpsPagos,
        FDevCobros,
        FDevPagos: TObjectList;


        procedure doSeparaSop;
        procedure doTextPrintHeadSop(listText: TStringList);
        procedure doTextPrintColHead(listText: TStringList);
        procedure doTextPrintRecord(listText: TStringList; aRecOp: TOpDivSystemRecord);
        procedure doTextPrintPreCobro(listText: TStringList);
        procedure doTextPrintPrePago(listText: TStringList);
        procedure doTextPrintDevCobro(listText: TStringList);
        procedure doTextPrintDevPago(listText: TStringList);
        procedure doTextPrintFootList(listRecs: TObjectList; listText: TStringList);
        procedure doTextPrintFootSop(listText: TStringList);
        procedure doShowPrint;

        procedure doPrinterPrint(Sender: TObject); 

      public
        constructor Create; virtual;
        destructor  Destroy; override;

        procedure Execute(aSop: TSoporte);
    end;

implementation

  uses
    Graphics,
    Printers,
    COpDivRecTypeDEV,
    VShowListadoText;

(********************
 FUNCIONES AUXILIARES
 ********************)

  function doCompare(Item1, Item2: Pointer): Integer;
  var
    rec1,
    rec2: TOpDivSystemRecord;
  begin
    rec1 := TOpDivSystemRecord(Item1);
    rec2 := TOpDivSystemRecord(Item2);

    Result := 0;
    // se compara primero por el tipo
    if rec1.RecType <> 'DEV' then
    begin
      if rec1.RecType < rec2.RecType then
        Result := -1
      else if rec1.RecType > rec2.RecType then
        Result := 1;
    end
    else  // devoluciones
    begin
      if TOpDivRecTypeDEV(rec1).TipoOpOriginal < TOpDivRecTypeDEV(rec2).TipoOpOriginal then
        Result := -1
      else if TOpDivRecTypeDEV(rec1).TipoOpOriginal > TOpDivRecTypeDEV(rec2).TipoOpOriginal then
        Result := 1;
    end;

    // ahora se ordena por la entidad
    if Result = 0 then
    begin
      if rec1.EntOficDestino < rec2.EntOficDestino then
        Result := -1
      else if rec1.EntOficDestino > rec2.EntOficDestino then
        Result := 1;
    end;

    // ahora se ordena por el importe
    if Result = 0 then
    begin
      if rec1.ImportePrinOp < rec2.ImportePrinOp then
        Result := -1
      else if rec1.ImportePrinOp > rec2.ImportePrinOp then
        Result := 1
    end;
  end;

(******************
 MÉTODOS PROTEGIDOS
 ******************)

  procedure TPrintSopAgent.doSeparaSop;
  var
    numOp: Integer;
    listaOps: TObjectList;
    recOp: TOpDivSystemRecord;
  begin
    listaOps := TObjectList.Create( FALSE );

    try
      FSoporte.getRegistros(listaOps);
      for numOp := 0 to listaOps.Count - 1 do
      begin
        recOp := TOpDivSystemRecord(listaOps.Items[numOp]);
        if recOp.OpNat = '1' then  // cobros
        begin
          if recOp.RecType <> 'DEV' then // no son devoluciones
            FOpsCobros.Add(recOp)
          else  // devoluciones
            FDevCobros.Add(recOp);
        end
        else  // pagos
        begin
          if recOp.RecType <> 'DEV' then  // no son devoluciones
            FOpsPagos.Add(recOp)
          else // devoluciones
            FDevPagos.Add(recOp);
        end
      end;

      // queda ordenar cada lista por separado
      FOpsCobros.Sort(doCompare);
      FOpsPagos.Sort(doCompare);
      FDevCobros.Sort(doCompare);
      FDevPagos.Sort(doCompare);
    finally
      listaOps.Free();
    end
  end;

  procedure TPrintSopAgent.doTextPrintHeadSop(listText: TStringList);
  begin
    listText.Add('FECHA: ' + formatDateTime('dd/mm/yyyy', FSoporte.FechaSoporte)
       + MS(' ', 4) + 'NÚM.ORDEN: ' + intToStr(FSoporte.NumOrden)
       + MS(' ', 4) + 'CARÁCTER: ' + FSoporte.tipoToStr(FSoporte.Tipo));
    listText.Add(EmptyStr);
  end;

  procedure TPrintSopAgent.doTextPrintColHead(listText: TStringList);
  begin
    listText.Add( AddCharR('.', 'TIPO', 6)
         + MS(' ', 1) + AddCharR('.', 'FECHA', 10)
         + MS(' ', 1) + AddCharR('.', 'TERMINAL', 8)
         + MS(' ', 1) + AddCharR('.', 'REFERENCIA', 16)
         + MS(' ', 1) + AddCharR('.', 'OFI.ORIG.', 9)
         + MS(' ', 1) + AddCharR('.', 'ENT.OFIC.DEST.', 14)
         + MS(' ', 1) + AddCharR('.', 'NÚM. CUENTA', 12)
         + MS(' ', 1) + AddChar('.', 'IMP.PRINCIP.', 18)
         + MS(' ', 1) + AddChar('.', 'IMP. ORIGEN', 18)
    );
    listText.Add(MS('_', 119));
  end;

  procedure TPrintSopAgent.doTextPrintRecord(listText: TStringList; aRecOp: TOpDivSystemRecord);
  var
    linea: String;
  begin
    // el tipo
    if aRecOp.RecType = 'DEV' then
      linea := 'DEV-' + TOpDivRecTypeDEV(aRecOp).TipoOpOriginal
    else
      linea := '  ' + aRecOp.RecType + '  ';
    linea := linea + MS(' ', 1) + FormatDateTime('dd-mm-yyyy', aRecOp.DateCreation);
    linea := linea + MS(' ', 1) + AddChar(' ', aRecOp.StationID, 8);
    linea := linea + MS(' ', 1) + AddChar(' ', aRecOp.OpRef, 16);
    linea := linea + MS(' ', 1) + AddChar(' ', copy(aRecOp.EntOficOrigen, 1, 4) + '-' + copy(aRecOp.EntOficOrigen, 5, 4), 9);
    linea := linea + MS(' ', 1) + AddChar(' ', copy(aRecOp.EntOficDestino, 1, 4) + '-'
         + copy(aRecOp.EntOficDestino, 5, 4) + '-' + aRecOp.DCEntOficDestino, 14);
    linea := linea + MS(' ', 1) + AddChar(' ', aRecOp.DCNumCtaDestino + '-' + aRecOp.NumCtaDestino, 12);
    linea := linea + MS(' ', 1) + AddChar(' ', FloatToStrF(aRecOp.ImportePrinOp, ffNumber, 16, 2) + ' €', 18);
    linea := linea + MS(' ', 1) + AddChar(' ', FloatToStrF(aRecOp.ImporteOrigOp, ffNumber, 15, 0) + ' Pt', 18);

    listText.Add( linea );
  end;

  procedure TPrintSopAgent.doTextPrintPreCobro(listText: TStringList);
  var
    iNumRec: Integer;
  begin
    if FOpsCobros.Count > 0 then
    begin
      listText.Add('PRESENTACIONES - COBROS');
      listText.Add(EmptyStr);
      doTextPrintColHead(listText);
      // se introducen los datos de cada registro
      for iNumRec := 0 to FOpsCobros.Count - 1 do
        doTextPrintRecord(listText, TOpDivSystemRecord(FOpsCobros.Items[iNumRec]));
      // se imprime el pie...
      doTextPrintFootList(FOpsCobros, listText);
      // se separa del resto de los datos
      listText.Add(EmptyStr);
    end;
  end;

  procedure TPrintSopAgent.doTextPrintPrePago(listText: TStringList);
  var
    iNumRec: Integer;
  begin
    if FOpsPagos.Count > 0 then
    begin
      listText.Add('PRESENTACIONES - PAGOS');
      listText.Add(EmptyStr);
      doTextPrintColHead(listText);
      // se introducen los datos de cada registro
      for iNumRec := 0 to FOpsPagos.Count-1 do
        doTextPrintRecord(listText, TOpDivSystemRecord(FOpsPagos.Items[iNumRec]));
      // se imprime el pie...
      doTextPrintFootList(FOpsPagos, listText);
      // se separa del resto de los datos
      listText.Add(EmptyStr);
    end;
  end;

  procedure TPrintSopAgent.doTextPrintDevCobro(listText: TStringList);
  var
    iNumRec: Integer;
  begin
    if FDevCobros.Count > 0 then
    begin
      listText.Add('DEVOLUCIONES - COBROS');
      listText.Add(EmptyStr);
      doTextPrintColHead(listText);
      // se introducen los datos de cada registro
      for iNumRec := 0 to FDevCobros.Count-1 do
        doTextPrintRecord(listText, TOpDivSystemRecord(FDevCobros.Items[iNumRec]));
      // se imprime el pie...
      doTextPrintFootList(FDevCobros, listText);
      // se separa del resto de los datos
      listText.Add(EmptyStr);
    end;
  end;

  procedure TPrintSopAgent.doTextPrintDevPago(listText: TStringList);
  var
    iNumRec: Integer;
  begin
    if FDevPagos.Count > 0 then
    begin
      listText.Add('DEVOLUCIONES - PAGOS');
      listText.Add(EmptyStr);
      doTextPrintColHead(listText);
      // se introducen los datos de cada registro
      for iNumRec := 0 to FDevPagos.Count-1 do
        doTextPrintRecord(listText, TOpDivSystemRecord(FDevPagos.Items[iNumRec]));
      // se imprime el pie...
      doTextPrintFootList(FDevPagos, listText);
      // se separa del resto de los datos
      listText.Add(EmptyStr);
    end;
  end;

  procedure TPrintSopAgent.doTextPrintFootList(listRecs: TObjectList; listText: TStringList);
  var
    numRec: Integer;
    sumaImportes: Double;
  begin
    sumaImportes := 0.0;
    for numRec := 0 to listRecs.Count-1 do
      sumaImportes := sumaImportes + TOpDivSystemRecord(listRecs.Items[numRec]).ImportePrinOp;
    // se introduce la línea de total
    listText.Add(
                        MS(' ', 6)
         + MS(' ', 1) + MS(' ', 10)
         + MS(' ', 1) + MS(' ', 8)
         + MS(' ', 1) + MS(' ', 16)
         + MS(' ', 1) + MS(' ', 9)
         + MS(' ', 1) + MS(' ', 14)
         + MS(' ', 1) + MS(' ', 12)
         + MS(' ', 1) + MS('_', 18)
    );
    listText.Add( AddCharR(' ', '  Número registros.. ' + FloatToStrF(listRecs.Count, ffNumber, 8, 0), 6+1+10+1+8+1+16+1+9+1+14+1+12)
         + MS(' ', 1) + AddChar(' ', FloatToStrF( sumaImportes, ffNumber, 15, 2) + ' €', 18) );
  end;

  procedure TPrintSopAgent.doTextPrintFootSop(listText: TStringList);
  begin

  end;

  procedure TPrintSopAgent.doShowPrint;
  var
    listText: TStringList;
    prnShow: TShowListadoTextForm;
  begin
    listText := TStringList.Create();
    prnShow  := TShowListadoTextForm.Create(nil);
    try
      // se crea el listado en modo texto para mostrarlo en la ventana...
      doTextPrintHeadSop(listText);
      doTextPrintPreCobro(listText);
      doTextPrintPrePago(listText);
      doTextPrintDevCobro(listText);
      doTextPrintDevPago(listText);
      doTextPrintFootSop(listText);
      // y se muestra, asociando el botón de impresión a la rutina oportuna
      prnShow.listadoMemo.Lines.Assign(listText);
      prnShow.imprimirButton.OnClick := doPrinterPrint;
      prnShow.ShowModal();
    finally
      listText.Free();
      prnShow.Free();
    end;
  end;

  procedure TPrintSopAgent.doPrinterPrint(Sender: TObject);
  const
    MARGEN_DERECHO  = 18;
    MARGEN_SUPERIOR = 35;
    LINEA_MUESTRA   = '0123456789abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ/?@#|';
    INTERLINEADO    = 2;
  var
    listText: TStringList;

    xPos, yPos,
    numPagina: Integer;

    procedure doIncLine;
    begin
      yPos := yPos + Printer.Canvas.TextHeight(LINEA_MUESTRA) + INTERLINEADO;
    end;

    procedure doInitiaData;
    begin
      xPos := MARGEN_DERECHO;
      yPos := MARGEN_SUPERIOR;
    end;

    procedure doPrinterPrintHead;
    begin
      Printer.Canvas.TextOut(xPos, yPos, 'FECHA: ' + formatDateTime('dd/mm/yyyy', FSoporte.FechaSoporte)
       + MS(' ', 4) + 'NÚM.ORDEN: ' + intToStr(FSoporte.NumOrden)
       + MS(' ', 4) + 'CARÁCTER: ' + FSoporte.tipoToStr(FSoporte.Tipo));
      doIncLine();
      doIncLine();
      doIncLine();
    end;

    procedure doPrinterPrintFeet;
    begin
      yPos := Printer.PageHeight - (3 * MARGEN_SUPERIOR);
      Printer.Canvas.Pen.Color := clBlack;
      Printer.Canvas.Pen.Style := psSolid;
      Printer.Canvas.Pen.Width := 2;
      Printer.Canvas.MoveTo(xPos, yPos);
      Printer.Canvas.LineTo(Printer.PageWidth - MARGEN_DERECHO, yPos);
      Printer.Canvas.Pen.Width := 1;
      yPos := yPos + 4;
      Printer.Canvas.TextOut(xPos, yPos, 'PÁGINA : ' + intToStr(numPagina));
      inc(numPagina);
    end;

    procedure doPrinterPrintTextList;
    var
      numLine,
      totWidth: Integer;
    begin
      totWidth := (Printer.Canvas.TextHeight(LINEA_MUESTRA) + INTERLINEADO) * listText.Count;
      if totWidth + yPos > (Printer.PageHeight - (3 * MARGEN_SUPERIOR)) then
      begin
        doPrinterPrintFeet();
        Printer.NewPage();
        doInitiaData();
        doPrinterPrintHead();
      end;
      for numLine := 0 to listText.Count - 1 do
      begin
        Printer.Canvas.TextOut(xPos, yPos, listText.Strings[numLine]);
        doIncLine();
      end;
      doIncLine();
      doIncLine();
    end;

  begin
    // funciona muy parecido al anterior, pero con la salvedad de que ahora se imprime cada bloque a la impresora...
    listText := TStringList.Create();
    try
      numPagina := 1;
      // orientación del papel
      Printer.Orientation := poLandscape;
      Printer.BeginDoc();
      Printer.Title := 'Soporte ' + formatDateTime('yyyymmdd', FSoporte.FechaSoporte) + '-' + IntToStr(FSoporte.NumOrden);
      // se establece la fuente
      Printer.Canvas.Font.Name := 'COURIER NEW';
      Printer.Canvas.Font.Size := 10;
      // se comienza a imprimir...
      doInitiaData();
      doPrinterPrintHead();

      // vamos imprimiendo cada parte...
      doTextPrintPreCobro(listText);
      doPrinterPrintTextList();
      listText.Clear();
      doTextPrintPrePago(listText);
      doPrinterPrintTextList();
      listText.Clear();
      doTextPrintDevCobro(listText);
      doPrinterPrintTextList();
      listText.Clear();
      doTextPrintDevPago(listText);
      doPrinterPrintTextList();
      listText.Clear();

      // se imprime el último pie de página
      doPrinterPrintFeet();
    finally
      Printer.EndDoc();
    end;
  end;


(****************
 MÉTODOS PÚBLICOS
 ****************)

  //*** CONSTRUCTORES Y DESTRUCTORES ****
  constructor TPrintSopAgent.Create;
  begin
    inherited;

    FOpsCobros := TObjectList.Create(FALSE);
    FOpsPagos  := TObjectList.Create(FALSE);
    FDevCobros := TObjectList.Create(FALSE);
    FDevPagos  := TObjectList.Create(FALSE);
  end;

  destructor TPrintSopAgent.Destroy;
  begin
    FOpsCobros.Free();
    FOpsPagos.Free();
    FDevCobros.Free();
    FDevPagos.Free();

    inherited;
  end;

  //***** interfase con las clases externas ****

  procedure TPrintSopAgent.Execute(aSop: TSoporte);
  begin
    FSoporte := aSop;
    doSeparaSop();
    doShowPrint();
  end;

end.
