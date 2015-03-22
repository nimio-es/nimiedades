unit CGenSopAgent;

interface

  uses
    SysUtils,
    Contnrs,
    ComCtrls,
    Controls,
    Dialogs,
    Forms,
    COpDivSystemRecord,
    CSoporte,
    CCustomDBMiddleEngine,
    CDBMiddleEngine,
    VConstSoporte,
    VSelRecSoporteForm,
    VGenSopFile;

  type

    TGenSopAgent = class( TObject )
      private
        FFechaSoporte: TDateTime;
//        FNumeroSoporte: Integer;
        FSoportes: TObjectList;

        SelRecForm: TSelRecSoporteForm;
        ConstSoporte: TConstSoporteForm;

        GenSopFile: TGenSopFileForm;

        // para la construcción del soporte
        FCurrentSoporte: TSoporte;    // soporte sobre el que se trabaja actualmente
        FAvalRecords : TObjectList;   // todos los registros no asociados actualmente
//        FShownRecords: TObjectList;   // mostrados que caigan en una de las dos categorías (doc. o no doc.) y que no estén previnculados ya
        FPreAsociated: TObjectList;   // los registros previnculados
//        FOldAsociated: TObjectList;   // cuando se trata de modificar un soporte, los que ya habían sido asociados antiguamente

        procedure ReadSoportes( aDate: TDateTime );
        procedure ReadAvailRecords;

        // auxiliared para la administración de soportes
        procedure showSoportes;

        // auxiliares para la composición
        procedure showDisponibles;
        procedure showAsociados;
        procedure saveSoporte;

        procedure ChangeFechaSoporte( Sender: TObject );
        procedure ChangeSelectedSoporte( Sender: TObject );
        // los eventos de la ventana de soportes
        procedure pressNewButton( Sender: TObject );
        procedure pressDelSoporteButton( Sender: TObject );
        procedure pressGenSopButton( Sender: TObject );
        procedure pressPtnSopButton( Sender: TObject );

        // los eventos de la ventana de composición del soporte
        procedure changeTipoSoporte( sender: TObject );
        procedure pressAddButton( Sender: TObject );
        procedure pressAddAllButton( Sender: TObject );
        procedure pressDelButton( Sender: TObject );
        procedure pressDelAllButton( Sender: TObject );
        procedure pressAceptarButton( Sender: TObject );
        procedure pressCancelarButton( Sender: TObject );
        procedure pressIncluirCheckBox(Sender: TObject);

        // los eventos de la ventana de generación del fichero
        procedure pressProcederFileButton(Sender: TObject);
        procedure pressCancelarFileButton(Sender: TObject);

      public
        procedure execute;
    end;

implementation

uses
  rxStrUtils,
  UAuxRefOp,
  Classes,
  Graphics,
  COpDivRecTypeDEV,
  CPrintSopAgent;

(***********
  PROCEDIMIENTOS AUXILIARES
 ***********)

function OrdenaListaRegistros(Item1, Item2: Pointer): Integer;
begin
  Result := 0;
  // a partir de ahora hay que colocar los registros de operaciones por delante
  // de los registros de devolución independientemente de la naturaleza...
  if (TOpDivSystemRecord(Item1).RecType <> 'DEV') and (TOpDivSystemRecord(Item2).RecType = 'DEV') then
    Result := -1
  else if (TOpDivSystemRecord(Item1).RecType = 'DEV') and (TOpDivSystemRecord(Item2).RecType <> 'DEV') then
    Result := 1
  else
  begin
    // se empieza ordenando por la naturaleza de la operación (cobros/pagos)
    if TOpDivSystemRecord(Item1).OpNat < TOpDivSystemRecord(Item2).OpNat then
      Result := -1
    else if TOpDivSystemRecord(Item1).OpNat > TOpDivSystemRecord(Item2).OpNat then
      Result := 1
    else
    begin
      // luego por el tipo de operación
      if TOpDivSystemRecord(Item1).RecType < TOpDivSystemRecord(Item2).RecType then
        Result := -1
      else if TOpDivSystemRecord(Item1).RecType > TOpDivSystemRecord(Item2).RecType then
        Result := 1
      else
      begin
        // luego por la entidad
        if TOpDivSystemRecord(Item1).EntOficDestino < TOpDivSystemRecord(Item2).EntOficDestino then
          Result := -1
        else if TOpDivSystemRecord(Item1).EntOficDestino > TOpDivSystemRecord(Item2).EntOficDestino then
          Result := 1
        else
        begin
          // y para acabar, se ordena de forma descendiente por importes...
          if TOpDivSystemRecord(Item1).ImportePrinOp < TOpDivSystemRecord(Item2).ImportePrinOp then
            Result := 1
          else if TOpDivSystemRecord(Item1).ImportePrinOp < TOpDivSystemRecord(Item2).ImportePrinOp then
            Result := -1
        end
      end
    end
  end
end;

(***********
  MÉTODOS PRIVADOS
 ***********)

procedure TGenSopAgent.ReadSoportes( aDate: TDateTime );
begin
  if assigned( FSoportes ) then FSoportes.Free();
  FSoportes := TheDBMiddleEngine.getListOfSoportes( aDate );
end;

procedure TGenSopAgent.ReadAvailRecords;
var
  listOfProxies: TObjectList;
  iProxy: Integer;
  newRecord: TOpDivSystemRecord;
begin
//  if not assigned( FAvalRecords ) then FAvalRecords := TObjectList.Create();
  FAvalRecords.Clear();

  listOfProxies := TheDBMiddleEngine.getListOfRecords();
  try
    // ahora vamos recorriendo la lista de proxies buscando leyendo los registros
    // y construyendo la lista oportuna. Eso sí, se pregunta primero si ya se tiene
    // está asociado o no a otro soporte...
    for iProxy := 0 to listOfProxies.Count - 1 do
    begin
      if not TheDBMiddleEngine.recordIsInSoporte( TOpDivRecordProxy( listOfProxies.Items[iProxy] ) ) then
      begin
        newRecord := TOpDivSystemRecord( theDBMiddleEngine.readRecord( TCustomRecordProxy( listOfProxies.Items[iProxy] ) ) );
        FAvalRecords.Add( newRecord );
      end
    end;
    // pero como somos muy pijos, lo queremos ordenado
    FAvalRecords.Sort(OrdenaListaRegistros);
  finally
    listOfProxies.Free();
    TheDBMiddleEngine.clearProxy();  // -- limpiamos el estado interno
  end;
end;

procedure TGenSopAgent.showSoportes;
var
  iSoporte: Integer;
  newItem: TListItem;
  theSoporte: TSoporte;
begin
  SelRecForm.soportesListView.Clear();
  for iSoporte := 0 to FSoportes.Count - 1 do
  begin
    theSoporte := TSoporte(FSoportes.Items[iSoporte]);
    newItem := SelRecForm.soportesListView.Items.Add();
    newItem.Data := theSoporte;
    newItem.Caption := theSoporte.tipoToStr(theSoporte.Tipo);
    newItem.SubItems.Add(theSoporte.StationID);
    newItem.SubItems.Add(timeToStr(theSoporte.FechaSoporte));
    newItem.SubItems.Add(intToStr(theSoporte.NumOrden));
    newItem.SubItems.Add(floatToStrF(theSoporte.Importe, ffNumber, 12, 2) + ' €');
    newItem.SubItems.Add(intToStr(theSoporte.NumRegistros));
  end;
end;

procedure TGenSopAgent.showDisponibles;
var
  searchDocs: boolean;
  iRecord: Integer;
  newItem: TListItem;
  addDisponibles: Boolean;
begin
  // se elimina lo que esté en ese momento activo...
  ConstSoporte.disponiblesListView.Clear();  

  searchDocs := FCurrentSoporte.Tipo = tsDocumental ;
  for iRecord := 0 to FAvalRecords.Count - 1 do
  begin
//    addDisponibles := false;

    if TOpDivSystemRecord( FAvalRecords.Items[iRecord] ).RecType <> 'DEV' then
      addDisponibles := (TOpDivSystemRecord( FAvalRecords.Items[ iRecord ] ).isDocumentable = searchDocs)
    else
      addDisponibles := (TOpDivRecTypeDEV(FAvalRecords.Items[iRecord]).isDocumentable() = searchDocs);

    // $27/10/2001 - a partir de ahora también se comprueban los que están pendientes de decidir si asociar o no
    if not ConstSoporte.IncluirPendientesCheckBox.Checked then
     addDisponibles := addDisponibles and TOpDivSystemRecord(FAvalRecords.Items[iRecord]).IncluirSoporte;

    addDisponibles := addDisponibles and (FPreAsociated.IndexOf(FAvalRecords.Items[iRecord]) = -1);

    if addDisponibles then
    begin
      newItem := ConstSoporte.disponiblesListView.Items.Add();
      newItem.Data := FAvalRecords.Items[ iRecord ];
      newItem.Caption := TOpDivSystemRecord( FAvalRecords.Items[ iRecord ] ).StationID;
      newItem.SubItems.Add( TOpDivSystemRecord( FAvalRecords.Items[iRecord] ).RecType );
      newItem.SubItems.Add( TOpDivSystemRecord( FAvalRecords.Items[iRecord] ).OpRef );
      newItem.SubItems.Add( TopDivSystemRecord.getOpNatDesc( TOpDivSystemRecord( FAvalRecords.Items[iRecord] ).OpNat ) );
      newItem.SubItems.Add( Copy( TOpDivSystemRecord( FAvalRecords.Items[iRecord] ).EntOficDestino, 1, 4 )
                + '-' + Copy( TOpDivSystemRecord( FAvalRecords.Items[iRecord] ).EntOficDestino, 5, 4 ) );
      newItem.SubItems.Add( dateTimeToStr( TOpDivSystemRecord( FAvalRecords.Items[iRecord] ).DateCreation ) );
      newItem.SubItems.Add( floatToStrF( TOpDivSystemRecord( FAvalRecords.Items[iRecord] ).ImportePrinOp, ffNumber, 10, 2 ) + ' €');
    end
  end;

  // además, activamos o desactivamos el botón de añadir todos dependiendo de si hay o no hay elementos para añadir...
  ConstSoporte.addAllButton.Enabled := (ConstSoporte.disponiblesListView.Items.Count > 0);
end;

procedure TGenSopAgent.showAsociados;
var
  iRecord: Integer;
  newItem: TListItem;
begin
  ConstSoporte.vinculadosListView.Clear();

  for iRecord := 0 to FPreAsociated.Count - 1 do
  begin
    newItem := ConstSoporte.vinculadosListView.Items.Add();
    newItem.Data := FPreAsociated.Items[ iRecord ];
    newItem.Caption := TOpDivSystemRecord( FPreAsociated.Items[ iRecord ] ).StationID;
    newItem.SubItems.Add( TOpDivSystemRecord( FPreAsociated.Items[iRecord] ).RecType );
    newItem.SubItems.Add( TOpDivSystemRecord( FPreAsociated.Items[iRecord] ).OpRef );
    newItem.SubItems.Add( TopDivSystemRecord.getOpNatDesc( TOpDivSystemRecord( FPreAsociated.Items[iRecord] ).OpNat ) );
    newItem.SubItems.Add( Copy( TOpDivSystemRecord( FPreAsociated.Items[iRecord] ).EntOficDestino, 1, 4 )
              + '-' + Copy( TOpDivSystemRecord( FPreAsociated.Items[iRecord] ).EntOficDestino, 5, 4 ) );
    newItem.SubItems.Add( dateTimeToStr( TOpDivSystemRecord( FPreAsociated.Items[iRecord] ).DateCreation ) );
    newItem.SubItems.Add( floatToStrF( TOpDivSystemRecord( FPreAsociated.Items[iRecord] ).ImportePrinOp, ffNumber, 10, 2 ) + ' €');
  end;

  // se activa/desactiva el botón de quitar todos
  ConstSoporte.delAllButton.Enabled := (ConstSoporte.vinculadosListView.Items.Count > 0);
  // los mismo con el de Aceptar
  ConstSoporte.aceptarButton.Enabled := (ConstSoporte.vinculadosListView.Items.Count > 0);
end;

procedure TGenSopAgent.saveSoporte;
var
  iNumRef: Integer;
  iRecord: Integer;  // índice del registro con el que vamos a trabajar momentáneamente...
  theRecord: TOpDivSystemRecord;
begin
  // en primer lugar hay que buscar el próximo número de serie para la referencia, atendiendo al día en cuestión
  iNumRef := TheDBMiddleEngine.getNextRefNumber();

  // a partir de este momento, hay que renumerar todos los registros, pero aquí es donde encontramos el mayor problema:
  // este nuevo número tiene que informarse en el archivo, por lo que tendremos que volver a guardar cada registro.
  // Existe la excepción de que no debemos cambiar un número de referencia si este ya ha sido asignado anteriormente
  for iRecord := 0 to FPreAsociated.Count - 1 do
  begin
    theRecord := TOpDivSystemRecord( FPreAsociated.Items[iRecord] );
    if theRecord.OpRef[16] = '?' then
    begin
      // le asociamos un nuevo número de referencia y lo guardamos en la BB.DD.
      theRecord.OpRef := getReferenciaOperacion( FCurrentSoporte.FechaSoporte, iNumRef );
      TheDBMiddleEngine.writeRecordNoProxy(theRecord);
      inc(iNumRef);
    end;
    FCurrentSoporte.AddRegistro(theRecord);
  end;

  // cuando ya hemos terminado de renumerar y de guardar todos los registros con nueva referencia, se procede a guardar el susodicho soporte
  TheDBMiddleEngine.writeSoporte(FCurrentSoporte);

  // también debemos indicar qué número de referencia es el último empleado en todo esto...
  TheDBMiddleEngine.setLastRefNumberUsed(iNumRef-1);
end;

procedure TGenSopAgent.ChangeFechaSoporte( Sender: TObject );
begin
  // 1º se buscan los soportes creados para esa fecha (creando la correspondiente lista)
  FFechaSoporte := TSelRecSoporteForm( Sender ).FechaSoporte ;
  ReadSoportes( FFechaSoporte );
  // 2º se rellena la lista de la ventana
  ShowSoportes();
  // se devuelve el control a la ventana para que el usuario siga trabajando
end;

procedure TGenSopAgent.ChangeSelectedSoporte( Sender: TObject );
var
  theRegistrosAsociados: TObjectList;
  iRecordVinculado: Integer;
  theRecord: TOpDivSystemRecord;
  newListItem: TListItem;
begin
  SelRecForm.vinculadosListView.Clear();
  if SelRecForm.soportesListView.Selected <> nil then
  begin
    SelRecForm.vinculadosListView.Color := clWindow;
    theRegistrosAsociados := TObjectList.Create(false);
    try
      TSoporte( SelRecForm.soportesListView.Selected.Data ).getRegistros(theRegistrosAsociados);
      theRegistrosAsociados.Sort(OrdenaListaRegistros);
      // se procede a mostrar los registros en la lista inferior
      for iRecordVinculado := 0 to theRegistrosAsociados.Count -1 do
      begin
        theRecord := TOpDivSystemRecord( theRegistrosAsociados.Items[iRecordVinculado] );
        newListItem := SelRecForm.vinculadosListView.Items.Add();
        newListItem.Caption := theRecord.OpRef;
        newListItem.SubItems.Add(theRecord.RecType);
        newListItem.SubItems.Add(theRecord.getOpNatDesc(theRecord.OpNat));
        newListItem.SubItems.Add(theRecord.EntOficDestino);
        newListItem.SubItems.Add(dateTimeToStr(theRecord.DateCreation));
        newListItem.SubItems.Add(floatToStrF(theRecord.ImportePrinOp,ffNumber,10,2) + ' €');
      end;
    finally
//      theRecord := nil;
      theRegistrosAsociados.Free();
    end;
  end
  else
    SelRecForm.vinculadosListView.Color := clBtnFace;
end;

(*
   -- cuando se pulsa el botón de añadir en el interfaz, hay que mostrar el diálogo oportuno que permite
      cambiar los registros (operaciones) asociadas al soporte. Por tanto sirve tanto para un soporte nuevo
      como para uno ya existente (modificación).
*)
procedure TGenSopAgent.pressNewButton( Sender: TObject );
begin
  // se preparan algunos datos iniciales
  FCurrentSoporte := TSoporte.Create();
  FCurrentSoporte.OwnsRecordsPointers := false;  // no se permite que el objeto elimine él las referencias

  FAvalRecords := TObjectList.Create();
  FAvalRecords.OwnsObjects := true;
  FPreAsociated := TObjectList.Create();
  FPreAsociated.OwnsObjects := false;

  FCurrentSoporte.FechaSoporte := now();
  FCurrentSoporte.NumOrden := TheDBMiddleEngine.getNextNumSoporte();

  readAvailRecords();

  ConstSoporte := TConstSoporteForm.Create( Application );
  try
    ConstSoporte.addButton.OnClick    := pressAddButton;
    ConstSoporte.addAllButton.OnClick := pressAddAllButton;
    ConstSoporte.delButton.OnClick    := pressDelButton;
    ConstSoporte.delAllButton.OnClick := pressDelAllButton;
    ConstSoporte.aceptarButton.OnClick := pressAceptarButton;
    ConstSoporte.cancelarButton.OnClick := pressCancelarButton;
    ConstSoporte.OnChangeNat          := changeTipoSoporte;
    ConstSoporte.IncluirPendientesCheckBox.OnClick := pressIncluirCheckBox;

    ConstSoporte.FechaSoporteEdit.Text := formatDateTime('dd/mm/yyyy',date()) + ' - ' + AddChar('0', intToStr(FCurrentSoporte.NumOrden), 3 );

    showDisponibles();
    showAsociados();

    ConstSoporte.ShowModal();
  finally
    ConstSoporte.Free();

    FPreAsociated.Clear();
    FPreAsociated.Free();
    FAvalRecords.Free();
    FCurrentSoporte.Free();
  end;

  ChangeFechaSoporte(SelRecForm);
end;

procedure TGenSopAgent.pressDelSoporteButton( Sender: TObject );
begin
  if SelRecForm.soportesListView.Selected <> nil then
  begin
    if MessageDlg('¿Confirma que desea eliminar este Soporte?', mtConfirmation, [mbYes, mbNo], 0 ) = mrYes then
    begin
      TheDBMiddleEngine.deleteSoporte( TSoporte(SelRecForm.soportesListView.Selected.Data) );
      // se releen los soportes asociados
      ReadSoportes(FFechaSoporte);
      showSoportes();
    end
  end
end;

procedure TGenSopAgent.pressGenSopButton( Sender: TObject );
begin
  if SelRecForm.soportesListView.Selected <> nil then
  begin
    FCurrentSoporte := TSoporte(SelRecForm.soportesListView.Selected.Data);
    genSopFile := TGenSopFileForm.Create(Application);
    try
      GenSopFile.procederBtn.OnClick := pressProcederFileButton; 
      GenSopFile.cancelarBtn.OnClick := pressCancelarFileButton;
      GenSopFile.NombreFichero := formatDateTime('yymmdd', FCurrentSoporte.FechaSoporte) + AddChar('0', intToStr(FCurrentSoporte.NumOrden), 2) + kFileGenSopExt;

      genSopFile.ShowModal();
    finally
      FCurrentSoporte := nil;
      genSopFile.Free();
    end;
  end
end;

procedure TGenSopAgent.pressPtnSopButton( Sender: TObject );
var
  prnAgent: TPrintSopAgent;
begin
  prnAgent := TPrintSopAgent.Create();
  try
    prnAgent.Execute(TSoporte(SelRecForm.soportesListView.Selected.Data));
  finally
    prnAgent.Free();
  end
end;

procedure TGenSopAgent.changeTipoSoporte( Sender: TObject );
var
  nuevoTipoSoporte: TTipoSoporte;
begin
  nuevoTipoSoporte := tsNoDocumental;
  if ConstSoporte.documentalRadioButton.Checked then
    nuevoTipoSoporte := tsDocumental;

  if FCurrentSoporte.Tipo <> nuevoTipoSoporte then
  begin
    FCurrentSoporte.Tipo := nuevoTipoSoporte;
    // en el proceso de cambio de tipo, desgraciadamente debemos eliminar los registros
    // ya asociados...
    FPreAsociated.Clear();
    showDisponibles();
    showAsociados();
  end
end;

procedure TGenSopAgent.pressAddButton( Sender: TObject );
begin
  if ConstSoporte.disponiblesListView.Selected <> nil then
  begin
    FPreAsociated.Add( ConstSoporte.disponiblesListView.Selected.Data );
    FPreAsociated.Sort(OrdenaListaRegistros);
    showDisponibles();
    showAsociados();
  end
end;

procedure TGenSopAgent.pressAddAllButton( Sender: TObject );
var
  iRecord: Integer;
  documental: boolean;
  addRecord: Boolean;
begin
  documental := ( FCurrentSoporte.Tipo = tsDocumental );
  // primero borramos todo lo ya previamente asociado para evitar duplicidades
  FPreAsociated.Clear();

  for iRecord := 0 to FAvalRecords.Count - 1 do
  begin
//    addRecord := false;
    if TOpDivSystemRecord(FAvalRecords.Items[iRecord]).RecType <> 'DEV' then
      addRecord := TOpDivSystemRecord( FAvalRecords.Items[iRecord] ).isDocumentable() = documental
    else
      addRecord := TOpDivRecTypeDEV(FAvalRecords.Items[iRecord]).isDocumentable() = documental;

    // tenemos que controlar que el registro no esté indicado para no incluirse y no esté activa la opción que obvia esto
    if not ConstSoporte.IncluirPendientesCheckBox.Checked then
      addRecord := addRecord and TOpDivSystemRecord(FAvalRecords.Items[iRecord]).IncluirSoporte;

    if addRecord then
      FPreAsociated.Add( FAvalRecords.Items[iRecord] );
  end;
  showDisponibles();
  showAsociados();
end;

procedure TGenSopAgent.pressDelButton( Sender: TObject );
var
  iRecord: Integer;
begin
  if ConstSoporte.vinculadosListView.Selected <> nil then
  begin
    iRecord := FPreAsociated.IndexOf( ConstSoporte.vinculadosListView.Selected.Data );
    FPreAsociated.Delete(iRecord);
    
    showDisponibles();
    showAsociados();
  end;
end;

procedure TGenSopAgent.pressDelAllButton( Sender: TObject );
begin
  FPreAsociated.Clear();
  showDisponibles();
  showAsociados();
end;

procedure TGenSopAgent.pressAceptarButton( Sender: TObject );
(*
var
  iRecord: Integer;
*)
begin
(*
  // procedemos a volcar el contenido de FPreAsociados, vinculándolos definitivamente con este soporte...
  for iRecord := 0 to FPreAsociated.Count - 1 do
    FCurrentSoporte.AddRegistro(TOpDivSystemRecord(FPreAsociated.Items[iRecord]));
*)
  // se debe almacenar el soporte en disco e introducir los datos de los registros asociados...
  saveSoporte();
  // damos por sentado que ya está almacenado y que podemos indicar que este es el último número asociado
  TheDBMiddleEngine.setLastNumSoporteUsed(FCurrentSoporte.NumOrden);
  ConstSoporte.ModalResult := mrOK;
end;

procedure TGenSopAgent.pressCancelarButton( Sender: TObject );
begin
  ConstSoporte.ModalResult := mrCancel;
end;

procedure TGenSopAgent.pressIncluirCheckBox(Sender: TObject);
begin
  showDisponibles();
end;

  //**** los eventos para la ventana de generación del archivo

  procedure TGenSopAgent.pressProcederFileButton(Sender: TObject);
  var
    iRecord: Integer;
    listaOperaciones: TObjectList;
    operacion: TOpDivSystemRecord;
    ficheroResultado: TStringList;
    loteRegistros: TStringList;
    parcialRegistros: TStringList;
    importeOp,
    importeLote,
    importeFile, importeDevFile: Double;
    iRecLote, iRecOp, iRecDetalle, iRecFile, iRecDetOpFile,
    iRecDetDevFile, iNumLotes, iNumPresenta,
    iCont,
    iOpCont,
    iOpNat: Integer;
    auxString: String;
    fechaDelSoporte: TDateTime;
    auxFechaSoporte: String;
    nameFile: String;

// $ 29/10/2001 -- A partir de ahora, para evitar la línea en blanco al final del fichero
//    se procederá a guardarlo en un archivo de TEXTO
    ficheroFinal: TEXT;
  begin
    // vamos a desactivar algunos controles en la ventana para evitar reentradas
    GenSopFile.procederBtn.Enabled := false;
    GenSopFile.DirectorioDestinoEdit.Enabled := false;
    GenSopFile.cancelarBtn.Enabled := false;
//    GenSopFile.depurarCheckBox.Enabled := false;

    listaOperaciones := TObjectList.Create(false);
    ficheroResultado := TStringList.Create();
    loteRegistros    := TStringList.Create();
    parcialRegistros := TStringList.Create();

    // $27/10/2001, a partir de ahora la fecha la cogemos del control que permite introducirla
//    fechaDelSoporte := FCurrentSoporte.FechaSoporte;
    fechaDelSoporte := GenSopFile.fechaCompensacionEdit.Date;
    auxFechaSoporte := formatDateTime('ddmmyyyy', fechaDelSoporte);
    try
      FCurrentSoporte.getRegistros(listaOperaciones);
      ficheroResultado.Clear();
      // si está activa la opción de depurar, metemos unas líneas en la cabecera del fichero que nos sirvan de guía
      if GenSopFile.Depurar then
      begin
        auxString := EmptyStr;
        for iCont := 1 to 3 do
          auxString := auxString + MS(' ',99) + Trim(IntToStr(iCont));
        ficheroResultado.Add(auxString);
        auxString := EmptyStr;
        for iCont := 1 to 35 do
          auxString := auxString + MS(' ',9) + Trim(IntToStr(iCont mod 10));
        ficheroResultado.Add(auxString);
        auxString := EmptyStr;
        for iCont := 1 to 352 do
          auxString := auxString + Trim( IntToStr( iCont mod 10 ) );
        ficheroResultado.Add(auxString);
      end;

      // CABECERA DEL FICHERO
      iRecFile := 0;
      iRecDetOpFile := 0;
      iRecDetDevFile := 0;
      iNumLotes := 0;
      iNumPresenta := 0;
      importeFile := 0.0;
      importeDevFile := 0.0;
      ficheroResultado.Add( AddCharR(' ',
                '01'
              + '62'
              + '0'
              + '00'
//              + formatDateTime('ddmmyyyy',FCurrentSoporte.FechaSoporte)
              + auxFechaSoporte
              + AddChar('0', intToStr(FCurrentSOporte.NumOrden), 4)
              + '20528888'
              + '2000'
                , 352) );

      // GENERAMOS LOS LOTES DE PRESENTACIÓN. PARE ESO SE REALIZAN DOS PASADAS. PRIMERO COBROS Y DESPUÉS PAGOS
      for iOpNat := 1 to 2 do
      begin
        // procedemos a inicializar los valores para cada lote y nos metemos de lleno en ir procesando los registros...
        iRecLote := 0;
        iRecDetalle := 0;
        importeLote := 0.0;
        loteRegistros.Clear();
        // CABECERA LOTE PRESENTACION
        loteRegistros.Add( AddCharR(' ',
                          '10'
                        + '62'
                        + Trim(IntToStr(iOpNat))
                        + '00'
//                        + formatDateTime('ddmmyyyy',FCurrentSoporte.FechaSoporte)
                        + auxFechaSoporte
                        + AddChar('0', intToStr(FCurrentSoporte.NumOrden), 4)
                        + '20528888'
                        + '2000'
                        , 352) );
        // se hacen catorce pasadas (igual a tipos de operación) para buscar los registros que pertenecen a cada operación
        // aunque sepamos que no se pueden dar ciertas operaciones según la naturaleza preferimos dejarlo así.
        for iOpCont := 1 to 14 do
        begin
          iRecOp := 0;
          importeOp := 0.0;
          parcialRegistros.Clear();
          // CABECERA LOTE PRESENTACION
          parcialRegistros.Add( AddCharR(' ',
                          '20'
                        + '62'
                        + Trim(IntToStr(iOpNat))
                        + AddChar('0', Trim(intToStr(iOpCont)), 2)
//                        + formatDateTime('ddmmyyyy',FCurrentSoporte.FechaSoporte)
                        + auxFechaSoporte
                        + AddChar('0', Trim(IntToStr(FCurrentSoporte.NumOrden)), 4)
                        + '20528888'
                        + '2000'
                        , 352) );
          // recorremos los registros
          for iRecord := 0 to listaOperaciones.Count - 1 do
          begin
            operacion := TOpDivSystemRecord(listaOperaciones.Items[iRecord]);
            if (operacion.OpNat = intToStr(iOpNat)) and (operacion.RecType = AddChar('0',intToStr(iOpCont),2)) then
            begin
              // SE AÑADE EL REGISTRO DETALLE DE LA OPERACION
              parcialRegistros.Add( operacion.getDataAsFileRecord() );
              inc(iRecOp);
              importeOp := importeOp + (Round(operacion.ImportePrinOp * 100.0) / 100.0);
            end
          end; // -- detalle de la operación
          // TOTAL DE OPERACIÓN DE PRESENTACIÓN
          parcialRegistros.Add( AddCharR(' ',
                          '40'
                        + '62'
                        + Trim(IntToStr(iOpNat))
                        + AddChar('0', Trim(IntToStr(iOpCont)), 2)
                        + '2052'
                        + '2000'
                        + AddChar('0', Trim(IntToStr(iRecOp)), 6)
                        + AddChar('0', Trim( ReplaceStr( ReplaceStr( FloatToStrF(importeOp,ffNumber,11,2), '.', ''), ',', '') ), 11)
                        + MS('0',6)
                        + MS('0',6)
                        , 352 ) );
          // en el caso de haberse encontrado alguna operación se deben añadir a la lista de registros del lote
          if iRecOp > 0 then
          begin
            iRecLote := iRecLote + iRecOp + 2;  // se incluyen la cabecera y el total de cada operación
            iRecDetalle := iRecDetalle + iRecOp; // en este sólo se indican el total de operaciones individuales
            inc(iNumLotes);
            importeLote := importeLote + importeOp;
            loteRegistros.AddStrings( parcialRegistros );
          end;
        end; // -- final del repaso de cada operación
        // TOTAL LOTE PRESENTACIÓN
        loteRegistros.Add( AddCharR( ' ',
                          '50'
                        + '62'
                        + Trim(IntToStr(iOpNat))
                        + '00'
//                        + formatDateTime('ddmmyyyy',FCurrentSoporte.FechaSoporte)
                        + auxFechaSoporte
                        + AddChar('0', Trim(IntTOstr(FCurrentSoporte.NumOrden)), 4)
                        + '20528888'
                        + '2000'
                        + AddChar('0', Trim(IntToStr(iRecLote+2)), 6)
                        + AddChar('0', Trim(IntToStr(iRecDetalle)), 6)
                        + AddChar('0', Trim( ReplaceStr( ReplaceStr( FloatToStrF(importeLote,ffNumber,11,2), '.', ''), ',', '') ), 11)
                        + MS('0',6)
                        + MS('0',6)
                        , 352 ) );

        // en el caso de haberse encontrado alguna operación de ese tipo se debe añadir todo el lote al fichero final
        if iRecDetalle > 0 then
        begin
          iRecFile := iRecFile + iRecLote + 2;
          iRecDetOpFile := iRecDetOpFile + iRecDetalle;
          inc(iNumPresenta);
          importeFile := importeFile + importeLote;
          ficheroResultado.AddStrings( loteRegistros );
        end;

      end; // -- fin del repaso de las operaciones (cobros/pagos)

      // DEVOLCIONES....
      // al igual que con las operaciones, se separan los cobros de los pagos
      for iOpNat := 1 to 2 do
      begin
        iRecLote := 0;
        importeLote := 0.0;
        loteRegistros.Clear();
        // se introduce la cabecera del lote de devolución
        loteRegistros.Add(AddCharR(' ',
                  '60'
                + '62'
                + intToStr(iOpNat)
                + '00'
                + auxFechaSoporte
                + AddChar('0', intTostr(FCurrentSoporte.NumOrden), 4)
                + '20528888'
                + '2000'
                , 352));
        // se recorren todos los registros buscando las devoluciones...
        for iRecord := 0 to listaOperaciones.Count - 1 do
        begin
          operacion := TOpDivSystemRecord(listaOperaciones.Items[iRecord]);
          if operacion.RecType = 'DEV' then
            if (operacion.OpNat = intToStr(iOpNat)) then
            begin
              // SE AÑADE EL REGISTRO DETALLE DE LA OPERACION
              loteRegistros.Add( TOpDivRecTypeDEV(operacion).getDataAsFileRecord() );
              inc(iRecLote);
              importeLote := importeLote + (Round(operacion.ImportePrinOp * 100.0) / 100.0);
            end
        end; // recorriendo los registros detalle...
        // introducimos el registro de total del lote de devoluciones...
        loteRegistros.Add(AddCharR(' ',
                  '80'
                + '62'
                + intToStr(iOpNat)
                + '00'
                + auxFechaSoporte
                + AddChar('0', intToStr(FCurrentSoporte.NumOrden), 4)
                + '20528888'
                + '2000'
                + AddChar('0', intToStr(iRecLote+2), 6)
                + AddChar('0', intToStr(iRecLote), 6)
                + AddChar('0', Trim( ReplaceStr( ReplaceStr( FloatToStrF(importeLote,ffNumber,11,2), '.', ''), ',', '') ), 11)
                + MS('0', 6)
                + MS('0', 6)
                , 352));
        // ahora se comprueba si hay que actualizar el resto de la variables globales y añadir...
        if iRecLote > 0 then
        begin
          inc(iNumLotes);
          inc(iNumPresenta);
          iRecFile := iRecFile + iRecLote + 2;
          iRecDetDevFile := iRecDetDevFile + iRecLote;
          importeDevFile := importeDevFile + importeLote;
          ficheroResultado.AddStrings( loteRegistros );
        end;
      end;  // iOpNar = 1 to 2...

      // TOTAL DEL FICHERO
      ficheroResultado.Add( AddCharR(' ',
                  '90'
                + '62'
                + '0'
                + '00'
                + AddChar('0', Trim( ReplaceStr( ReplaceStr( FloatToStrF(importeFile,ffNumber,12,2), '.', ''), ',', '') ), 12)
                + MS('0',8)
                + MS('0',8)
                + AddChar('0', Trim( ReplaceStr( ReplaceStr( FloatToStrF(importeDevFile,ffNumber,12,2), '.', ''), ',', '') ), 12)
                + MS('0',8)
                + MS('0',8)
//                + AddChar('0', Trim(IntToStr(iNumLotes)), 5)
                + AddChar('0', Trim(IntToStr(iNumPresenta)), 5)     
                + AddChar('0', Trim(IntToStr(iRecFile+2)), 7)
                + AddChar('0', Trim(IntToStr(iRecDetOpFile)), 6)
                + AddChar('0', Trim(IntToStr(iRecDetDevFile)), 6)
                , 352));

      // lo mostramos en la pantalla...
      GenSopFile.ShowFileMemo.Lines.Clear();
      GenSopFile.ShowFileMemo.Lines.AddStrings(ficheroResultado);
      // debemos guardarlo en el directorio indicado
      nameFile := GenSopFile.DirectorioDestino;
      if nameFile[length(nameFile)] <> '\' then
        nameFile := nameFile + '\';
      nameFile := nameFile + GenSopFile.NombreFichero;

//*********
//      ficheroResultado.SaveToFile(nameFile);
// $ 29/10/2001 -- hay que almacenarlo de forma que no se genere la línea del final del fichero

      AssignFile(ficheroFinal, nameFile);
      Rewrite(ficheroFinal);
      try
        for iRecord := 0 to ficheroResultado.Count - 2 do
          WriteLn(ficheroFinal, ficheroResultado.Strings[iRecord]);
        // la última fila se graba sin salto de línea
        Write(ficheroFinal, ficheroResultado.Strings[ficheroResultado.Count-1]);
      finally
        CloseFile(ficheroFinal);
      end;

      // asímismo lo guardamos en el directorio de seguimiento
      TheDBMiddleEngine.writeSopFile(GenSopFile.NombreFichero, ficheroResultado);
    finally
      listaOperaciones.Free();
      ficheroResultado.Free();
      loteRegistros.Free();
      parcialRegistros.Free();

      // reactivamos los controles
      GenSopFile.procederBtn.Enabled := true;
      GenSopFile.DirectorioDestinoEdit.Enabled := true;
      GenSopFile.cancelarBtn.Enabled := true;
//      GenSopFile.depurarCheckBox.Enabled := true;
    end
  end;

  procedure TGenSopAgent.pressCancelarFileButton(Sender: TObject);
  begin
    GenSopFile.ModalResult := mrCancel;
  end;


(***********
  MÉTODOS PÚBLICOS
 ***********)

procedure TGenSopAgent.execute;
begin
  if TheDBMiddleEngine.beginSoporteSection() then
  begin
    SelRecForm := TSelRecSoporteForm.Create(nil);
    // se conectan los procedimientos de control de eventos a los elementos de la interfaz
    SelRecForm.newButton.OnClick := pressNewButton;
    SelRecForm.delSoporteButton.OnClick := pressDelSoporteButton;
    SelRecForm.genSopButton.OnClick := pressGenSopButton;
    SelRecForm.prnSopButton.OnClick := pressPtnSopButton;

    // se introducen los datos iniciales
    SelRecForm.OnChangeFechaSoporte := ChangeFechaSoporte;
    SelRecForm.OnChangeSelected := ChangeSelectedSoporte;
    SelRecForm.FechaSoporte := Date();

    SelRecForm.ShowModal();

    SelRecForm.Free();

    TheDBMiddleEngine.endSoporteSection();
  end
  else
  begin
    MessageDlg( 'No se puede acceder a la gestión de soportes.'+#13+'Probablemente otro usuario esté accediendo en este momento.'
          + ' Inténtelo dentro de unos minutos. Si el problema persiste, llame a informática.', mtWarning ,[mbOK], 0 );
  end
end;

end.
