unit CListadoTipoOpAgent;

interface

  uses
    rxStrUtils,
    SysUtils,
    Classes,
    Contnrs,
    COpDivSystemRecord,
    COpDivRecType02,
    CDBMiddleEngine,
    CQueryEngine;

  const
    TIPO_OP_PARAM_FECHA_DESDE_INDEX = 0;
    TIPO_OP_PARAM_FECHA_HASTA_INDEX = 1;
    TIPO_OP_PARAM_DEVOLUCION_INDEX  = 15;

  type

    //***********************************
    TListadoTipoOpParams = class(TObject)
    //***********************************
      public
        FFechas: array[0..1] of TDateTime;
        FInidicarSoporte,
        FSepararPorSoporte,
        FSepararPorFechas,
        FSepararPorTerminales,
        FSepararPorTipos,
        FAnadirDatosCadaTipo,
        FSoloIncluirTipos,
        FSaltarPagina,
        FEmitirCuadorResumen: Boolean;
        FTiposAIncluir: array[1..15] of Boolean;

        Constructor Create; virtual;

        function isOneDayOnly: Boolean;
        function indicateSop: Boolean;
        function indicateSopAsCol: Boolean;
        function sopSeparation: Boolean;
        function dateSeparation: Boolean;
        function termSeparation: Boolean;
        function typeSeparation: Boolean;
        function addTypeInfo: Boolean;
        function newPageAfter: Boolean;
        function includeOp(tipoOp: Integer): Boolean;

    end;

    //**************
    TClusterNodeType = ( cntMain, cntSoporte, cntDate, cntTerm, cntRec, cntNat );
    //**************

    //***************************
    TClusterNode = class(TObject)
    //***************************
      public
        FNodeType: TClusterNodeType;
        FSoporte: String;
        FDate: TDateTime;
        FTerminal: String;
        FRecType: String;
        FOpNat: String;
        FListClusters: TObjectList;

        constructor Create; virtual;
        destructor Destroy; override;

        procedure insertRecord(aParams: TListadoTipoOpParams; anOpRecord: TOpDivSystemRecord);
    end;

    //**********************************
    TListadoTipoOpAgent = class(TObject)
    //**********************************
      protected
        FParams: TListadoTipoOpParams;
        FListado: TStringList;

        FOpNames: array[1..15] of String;

        FListaRegs: TObjectList;

        FMainCluster: TClusterNode;

        // variables contadores para cada cluster
        FWidthCols,
        FSpacesToImporte: Integer;
        FTotalImpPrinCluster,
        FTotalImpOrigCluster: Double;

        FTotalImpPrinCobroOpDia,
        FTotalImpOrigCobroOpDia,
        FTotalImpPrinPagosOpDia,
        FTotalImpOrigPagosOpDia,
        FTotalImpPrinCobroDevDia,
        FTotalImpOrigCobroDevDia,
        FTotalImpPrinPagosDevDia,
        FTotalImpOrigPagosDevDia: Double;

        FTotalImpPrinCobroOpSop,
        FTotalImpOrigCobroOpSop,
        FTotalImpPrinPagosOpSop,
        FTotalImpOrigPagosOpSop,
        FTotalImpPrinCobroDevSop,
        FTotalImpOrigCobroDevSop,
        FTotalImpPrinPagosDevSop,
        FTotalImpOrigPagosDevSop: Double;


        // buscamos la lista de registros
        procedure getOpList;


        procedure startClusterSum;
        procedure startSopClusterSum;
        procedure startDateClusterSum;
        procedure addClusterSum(anOpRecord: TOpDivSystemRecord);

        procedure printSopHeadCluster(aCluster: TClusterNode);
        procedure printSopFootCluster(aCluster: TClusterNode);
        procedure printFechaCluster(aCluster: TClusterNode);
        procedure printFechaFootCluster(aCluster: TClusterNode);
        procedure printTermCluster(aCluster: TClusterNode);
        procedure printRecTypeCluster(aCluster: TClusterNode);
        procedure printOpNatCluster(aCluster: TClusterNode);
        procedure printGenColsHead;
        procedure printGenSepColsHead;
        procedure printSpecificColsHead(aRecType: String);
        procedure printColsHead(aRecType: String);
        procedure printColsFoot;
        procedure printGenRecordData(aOpRecord: TOpDivSystemRecord);
        procedure printType02RecordData(anType02Record: TOpDivRecType02);
        procedure printSpecificRecordData(anOpRecord: TOpDivSystemRecord);
        procedure printRecordData(aOpRecord: TOpDivSystemRecord);

        procedure doPrintCluster(aCluster: TClusterNode);
        procedure doShowListView;
        procedure doList;

      public
        Constructor Create; virtual;
        Constructor CreateWithParams(aParams: TListadoTipoOpParams); virtual;
        Destructor  Destroy; override;

        procedure Execute; virtual;
        procedure ExecuteWithParams(aParams: TListadoTipoOpParams); virtual;

        procedure setParams(aParams: TListadoTipoOpParams); virtual;
    end;

implementation

  uses
    COpDivRecTypeDEV,
    VShowListadoText;

  const
    NUM_LIN_SEP_HEAD = 4;
    NUM_LIN_SEP_FEET = 4;

//************************
//* TLISTADOTIPOOPPARAMS *
//************************

  //******************
  // MÉTODOS PÚBLICOS
  //******************

  Constructor TListadoTipoOpParams.Create;
  var
    OpIndex: Integer;
  begin
    inherited;
    FFechas[TIPO_OP_PARAM_FECHA_DESDE_INDEX] := date();
    FFechas[TIPO_OP_PARAM_FECHA_HASTA_INDEX] := date();
    for OpIndex := 1 to TIPO_OP_PARAM_DEVOLUCION_INDEX do
      FTiposAIncluir[OpIndex] := TRUE;
  end;

  function TListadoTipoOpParams.isOneDayOnly: Boolean;
  begin
    Result := (FFechas[TIPO_OP_PARAM_FECHA_DESDE_INDEX] =
         FFechas[TIPO_OP_PARAM_FECHA_HASTA_INDEX]);
  end;

  function TListadoTipoOpParams.indicateSop: Boolean;
  begin
    Result := FInidicarSoporte;
  end;

  function TListadoTipoOpParams.indicateSopAsCol: Boolean;
  begin
    Result := indicateSop() and not sopSeparation();
  end;

  function TListadoTipoOpParams.sopSeparation: Boolean;
  begin
    Result := FSepararPorSoporte;
  end;

  function TListadoTipoOpParams.dateSeparation: Boolean;
  begin
    Result := FSepararPorFechas or isOneDayOnly();
    // cuando es para un día tb hay que separar por fechas, pero con la salvedad
    // de que se obtendrá un único cluster de fecha...
  end;

  function TListadoTipoOpParams.termSeparation: Boolean;
  begin
    Result := FSepararPorTerminales;
  end;

  function TListadoTipoOpParams.typeSeparation: Boolean;
  begin
    Result := FSepararPorTipos;
  end;

  function TListadoTipoOpParams.addTypeInfo: Boolean;
  begin
    Result := FAnadirDatosCadaTipo;
  end;

  function TListadoTipoOpParams.newPageAfter: Boolean;
  begin
    Result := FSaltarPagina;
  end;

  function TListadoTipoOpParams.includeOp(tipoOp: Integer): Boolean;
  begin
    Result := TRUE;
    if FSoloIncluirTipos then
      Result := FTiposAIncluir[tipoOp];
  end;

//***********************
//* TClusterNode        *
//***********************

  constructor TClusterNode.Create;
  begin
    inherited;
    FNodeType := cntMain;
    FListClusters := TObjectList.Create(true);
  end;

  destructor TClusterNode.Destroy;
  begin
    FListClusters.Free();
    inherited;
  end;

  procedure TClusterNode.insertRecord(aParams: TListadoTipoOpParams; anOpRecord: TOpDivSystemRecord);
  var
    numCluster: Integer;
    cluster,
    newCluster: TClusterNode;
    clusterEncontrado: Boolean;
    auxFecha: TDateTime;
  begin
//    clusterEncontrado := TRUE;
    cluster := Self;  // es el propio cluster...

    // procedemos a separar por el soporte
    if aParams.sopSeparation() then
    begin
      clusterEncontrado := FALSE;

      for numCluster := 0 to cluster.FListClusters.Count - 1 do
      begin
        if TClusterNode(cluster.FListClusters.Items[numCluster]).FSoporte = anOpRecord.Soporte then
        begin
          clusterEncontrado := TRUE;
          break;
        end;
        if TClusterNode(cluster.FListClusters.Items[numCluster]).FSoporte > anOpRecord.Soporte then
          break;
      end;
      if clusterEncontrado then
        cluster := TClusterNode(cluster.FListClusters.Items[numCluster])
      else
      begin
        newCluster := TClusterNode.Create();
        newCluster.FNodeType := cntSoporte;
        newCluster.FSoporte := anOpRecord.Soporte;
        if numCluster >= cluster.FListClusters.Count then
          cluster.FListClusters.Add(newCluster)
        else
          cluster.FListClusters.Insert(numCluster, newCluster);

        cluster := newCluster;
      end;
    end;  // -- sopSeparation()

    // procedemos a separar por la fecha
    if aParams.dateSeparation() then
    begin
      auxFecha := Trunc(anOpRecord.DateCreation);
      clusterEncontrado := FALSE;
(*
      numCluster := 0;
      while (numCluster < FListClusters.Count) and not clusterEncontrado do
        if TClusterNode(FListClusters.Items[numCluster]).FDate <> auxFecha then
          inc(numCluster)
        else
          clusterEncontrado := TRUE;
      // si no ha sido encontrado, tenemos entonces que proceder creandolo
      if not clusterEncontrado then
      begin
        numCluster := 0;
        while (numCluster < FListClusters.Count - 1) do
        begin
          if (TClusterNode(FListClusters.Items[numCluster]).FDate > auxFecha) then
            break;
          if (TClusterNode(FListClusters.Items[numCluster]).FDate < auxFecha)
                and (TClusterNode(FListClusters.Items[numCluster]).FDate > auxFecha) then
            break;
          inc(numCluster);
        end;
        cluster := TClusterNode.Create();
        cluster.FNodeType := cntDate;
        cluster.FDate := auxFecha;
        // sumamos uno y pasamos al siguiente, pero en el caso de ser el último debemos preguntar
        // si se trata del penúltimo o del último
        if (TClusterNode(FListClusters.Items[numCluster]).FDate > auxFecha) then
          FListClusters.Insert(numCluster, cluster)
        else if (TClusterNode(FListClusters.Items[numCluster]).FDate < auxFecha)
            and (TClusterNode(FListClusters.Items[numCluster + 1]).FDate > auxFecha) then
          FListClusters.Insert(numCluster + 1, cluster)
        else
          FListClusters.Add(cluster);
        //
        clusterEncontrado := TRUE;
      end
      else
        cluster := TClusterNode(FListClusters.Items[numCluster]);
*)
      for numCluster := 0 to cluster.FListClusters.Count - 1 do
      begin
        if TClusterNode(cluster.FListClusters.Items[numCluster]).FDate = auxFecha then
        begin
          clusterEncontrado := TRUE;
          break;
        end;
        if TClusterNode(cluster.FListClusters.Items[numCluster]).FDate > auxFecha then
          break;
      end;
      if clusterEncontrado then
        cluster := TClusterNode(cluster.FListClusters.Items[numCluster])
      else
      begin
        newCluster := TClusterNode.Create();
        newCluster.FNodeType := cntDate;
        newCluster.FDate := auxFecha;
        if numCluster >= cluster.FListClusters.Count then
          cluster.FListClusters.Add(newCluster)
        else
          cluster.FListClusters.Insert(numCluster, newCluster);

        cluster := newCluster;
      end;

    end;  // -- dateSeparation();
    // ahora procedemos a separar por el terminal... si procede
    if aParams.termSeparation() then
    begin
      clusterEncontrado := FALSE;
      for numCluster := 0 to cluster.FListClusters.Count - 1 do
      begin
        if TClusterNode(cluster.FListClusters.Items[numCluster]).FTerminal = anOpRecord.StationID then
        begin
          clusterEncontrado := TRUE;
          break;
        end;
        if TClusterNode(cluster.FListClusters.Items[numCluster]).FTerminal > anOpRecord.StationID then
          break;
      end;
      if clusterEncontrado then
        cluster := TClusterNode(cluster.FListClusters.Items[numCluster])
      else
      begin
        newCluster := TClusterNode.Create();
        newCluster.FNodeType := cntTerm;
        newCluster.FTerminal := anOpRecord.StationID;
        if numCluster >= cluster.FlistClusters.Count then
          cluster.FListClusters.Add(newCluster)
        else
          cluster.FListClusters.Insert(numCluster, newCluster);

        cluster := newCluster;
      end;
    end; // -- termSeparation()

    // ahora separamos por el tipo de operación
    if aParams.typeSeparation() then
    begin
      clusterEncontrado := FALSE;
      for numCluster := 0 to cluster.FListClusters.Count - 1 do
      begin
        if TClusterNode(cluster.FListClusters.Items[numCluster]).FRecType = anOpRecord.RecType then
        begin
          clusterEncontrado := TRUE;
          break;
        end;
        if TClusterNode(cluster.FListClusters.Items[numCluster]).FRecType > anOpRecord.RecType then
          break;
      end;
      if clusterEncontrado then
        cluster := TClusterNode(cluster.FListClusters.Items[numCluster])
      else
      begin
        newCluster := TClusterNode.Create();
        newCluster.FNodeType := cntRec;
        newCluster.FRecType  := anOpRecord.RecType;
        if numCluster >= cluster.FListClusters.Count then
          cluster.FListClusters.Add(newCluster)
        else if TClusterNode(cluster.FListClusters.Items[numCluster]).FRecType > anOpRecord.RecType then
          cluster.FListClusters.Insert(numCluster, newCluster);
        cluster := newCluster;
      end;
    end;

    // ahora separamos por la naturaleza
    clusterEncontrado := FALSE;
    for numCluster := 0 to cluster.FListClusters.Count - 1 do
    begin
      if TClusterNode(cluster.FListClusters.Items[numCluster]).FOpNat = anOpRecord.OpNat then
      begin
        clusterEncontrado := TRUE;
        break;
      end;
      if TClusterNode(cluster.FListClusters.Items[numCluster]).FOpNat > anOpRecord.OpNat then
        break;
    end;
    if clusterEncontrado then
      cluster := TClusterNode(cluster.FListClusters.Items[numCluster])
    else
    begin
      newCluster := TClusterNode.Create();
      newCluster.FNodeType := cntNat;
      newCluster.FRecType := anOpRecord.RecType;
      newCluster.FOpNat := anOpRecord.OpNat;
      if numCluster >= cluster.FListClusters.Count then
        cluster.FListClusters.Add(newCluster)
      else
        cluster.FListClusters.Insert(numCluster, newCluster);

      cluster := newCluster;
    end;

    // -- se añade el registro al cluster final
    cluster.FListClusters.Add(anOpRecord);
  end;

//***********************
//* TListadoTipoOpAgent *
//***********************

  //********************
  // MÉTODOS PROTEGIDOS
  //********************
    var
      separarPorSoportes,
      separarPorTerminales: Boolean;

  function ordenaListaRegistros(item1, item2: Pointer): integer;
  begin
    Result := 0;  // son iguales

    // se separa primero por soporte siempre que se haya indicado que se desea "partir" o "separar" por este dato
    if separarPorSoportes then
    begin
      if (TOpDivSystemRecord(item1).Soporte = EmptyStr) and (TOpDivSystemRecord(item2).Soporte <> EmptyStr) then
        Result := -1
      else if (TOpDivSystemRecord(item1).Soporte <> EmptyStr) and (TOpDivSystemRecord(item2).Soporte = EmptyStr) then
        Result := 1
      else
      begin
        if TOpDivSystemRecord(item1).Soporte > TOpDivSystemRecord(item2).Soporte then
          Result := 1
        else if TOpDivSystemRecord(item1).Soporte < TOpDivSystemRecord(item2).Soporte then
          Result := -1
      end
    end;

    // por la fecha
    if Result = 0 then
    begin
      if TOpDivSystemRecord(item1).DateCreation > TOpDivSystemRecord(item2).DateCreation then
        Result := 1
      else if TOpDivSystemRecord(item1).DateCreation < TOpDivSystemRecord(item2).DateCreation then
        Result := -1;
    end;

    // además debemos ordenar en base al criterio de la terminal dependiendo de
    // si queremos o no separar el listado por terminales
    if separarPorTerminales and (Result = 0) then
    begin
      if TOpDivSystemRecord(item1).StationID > TOpDivSystemRecord(item2).StationID then
        Result := 1
      else if TOpDivSystemRecord(item2).StationID < TOpDivSystemRecord(item2).StationID then
        Result := -1;
    end;

    // luego por el resto...
    if Result = 0 then
    begin
      if (TOpDivSystemRecord(item1).RecType <> 'DEV') and (TOpDivSystemRecord(item2).RecType = 'DEV') then
        Result := -1
      else if (TOpDivSystemRecord(item1).RecType = 'DEV') and (TOpDivSystemRecord(item2).RecType <> 'DEV') then
        Result := 1
      else // los dos son o una operación o devoluciones
      begin
        if (TOpDivSystemRecord(item1).RecType <> 'DEV') then
        begin
          if (TOpDivSystemRecord(item1).RecType > TOpDivSystemRecord(item2).RecType) then
            Result := 1
          else if(TOpDivSystemRecord(item1).RecType < TOpDivSystemRecord(item2).RecType) then
            Result := -1;
        end
        else
        begin
          // ordenamos dentro por el tipo original de la operación
          if(TOpDivRecTypeDEV(item1).TipoOpOriginal > TOpDivRecTypeDEV(item2).TipoOpOriginal) then
            Result := 1
          else if(TOpDivRecTypeDEV(item1).TipoOpOriginal < TOpDivRecTypeDEV(item2).TipoOpOriginal) then
            Result := -1;
        end;
        // para continuar ordenando por otros criterios debemos estar seguros de q. este no ha sido aplicado
        if Result = 0 then
        begin
          // ahora se ordena por la naturaleza de la operación (cobros/pagos)
          if TOpDivSystemRecord(item1).OpNat > TOpDivSystemRecord(item2).OpNat then
            Result := 1
          else if TOpDivSystemRecord(item1).OpNat < TOpDivSystemRecord(item2).OpNat then
            Result := -1
          else
          begin
            // ahora se ordena por la entidad-oficina de destino
            if TOpDivSystemRecord(item1).EntOficDestino > TOpDivSystemRecord(item2).EntOficDestino then
              Result := 1
            else if TOpDivSystemRecord(item1).EntOficDestino < TOpDivSystemRecord(item2).EntOficDestino then
              Result := -1
            else
            begin
              // por el importe
              if TOpDivSystemRecord(item1).ImportePrinOp > TOpDivSystemRecord(item2).ImportePrinOp then
                Result := 1
              else if TOpDivSystemRecord(item1).ImportePrinOp < TOpDivSystemRecord(item2).ImportePrinOp then
                Result := -1;
            end
          end
        end
      end
    end
  end;

  procedure TListadoTipoOpAgent.getOpList;
  var
    listaProxys: TObjectList;
    numProxy: Integer;
    auxNumTipoReg: Integer;
  begin
//    if assigned(FListaRegs) then FListaRegs.Free();

    // se lee la lista de proxys de los registros...
    FListaRegs := TObjectList.Create();
    listaProxys := TheDBMiddleEngine.getListOfRecords();
    try
      for numProxy := 0 to listaProxys.Count - 1 do
        // filtramos aquellos registros que no son necesarios leer
        // empezando por la fecha
        if ( Trunc(TOpDivRecordProxy(listaProxys.Items[numProxy]).FechaHora) >= FParams.FFechas[TIPO_OP_PARAM_FECHA_DESDE_INDEX] )
            and ( Trunc(TOpDivRecordProxy(listaProxys.Items[numProxy]).FechaHora) <= FParams.FFechas[TIPO_OP_PARAM_FECHA_HASTA_INDEX] ) then
        begin
          if TOpDivRecordProxy(listaProxys.Items[numProxy]).TipoReg = 'DEV' then
            auxNumTipoReg := TIPO_OP_PARAM_DEVOLUCION_INDEX
          else
            auxNumTipoReg := strToInt(TOpDivRecordProxy(listaProxys.Items[numProxy]).TipoReg);
          // luego se comprueba que pertenece al grupo de operaciones a imprimir
          if FParams.includeOp(auxNumTipoReg) then
            FListaRegs.Add(TheDBMiddleEngine.readRecord(TOpDivRecordProxy(listaProxys.Items[numProxy])));
        end
    finally
      listaProxys.Free();
    end;
    // debemos ordenarla en base al tipo, ala fecha y al terminal
    separarPorSoportes   := FParams.sopSeparation();
    separarPorTerminales := FParams.termSeparation();
    FListaRegs.Sort(ordenaListaRegistros);

    TheDBMiddleEngine.clearProxy();
  end;

(*
  procedure TListadoTipoOpAgent.addPageHead;
  var
    numLinHead: Integer;
  begin
    for numLinHead := 1 to NUM_LIN_SEP_HEAD do
      FListado.Add(EmptyStr);
  end;

  procedure TListadoTipoOpAgent.addPageFeet;
  var
    numLinFeet: Integer;
  begin
    for numLinFeet := 1 to NUM_LIN_SEP_FEET do
      FListado.Add(EmptyStr);
  end;

  procedure TListadoTipoOpAgent.addTitleOp;
  begin
//    FListado.Add('  TIPO OPERACION: ' + AddCharR('0', intToStr(currentOp), 2) + ' - ' + FOpNames[currentOp]);
  end;

  procedure TListadoTipoOpAgent.addGenColsHead;
  begin
  end;

  procedure TListadoTipoOpAgent.addColsHead;
  begin
  end;
*)

  procedure TListadoTipoOpAgent.startClusterSum;
  begin
    FTotalImpPrinCluster := 0.0;
    FTotalImpOrigCluster := 0.0;
  end;

  procedure TListadoTipoOpAgent.startSopClusterSum;
  begin
    FTotalImpPrinCobroOpSop  := 0.0;
    FTotalImpOrigCobroOpSop  := 0.0;
    FTotalImpPrinPagosOpSop  := 0.0;
    FTotalImpOrigPagosOpSop  := 0.0;
    FTotalImpPrinCobroDevSop := 0.0;
    FTotalImpOrigCobroDevSop := 0.0;
    FTotalImpPrinPagosDevSop := 0.0;
    FTotalImpOrigPagosDevSop := 0.0;
  end;

  procedure TListadoTipoOpAgent.startDateClusterSum;
  begin
    FTotalImpPrinCobroOpDia  := 0.0;
    FTotalImpOrigCobroOpDia  := 0.0;
    FTotalImpOrigPagosOpDia  := 0.0;
    FTotalImpPrinPagosOpDia  := 0.0;
    FTotalImpPrinCobroDevDia := 0.0;
    FTotalImpOrigCobroDevDia := 0.0;
    FTotalImpOrigPagosDevDia := 0.0;
    FTotalImpPrinPagosDevDia := 0.0;
  end;

  procedure TListadoTipoOpAgent.addClusterSum(anOpRecord: TOpDivSystemRecord);
  begin
    FTotalImpPrinCluster := FTotalImpPrinCluster + anOpRecord.ImportePrinOp;
    FTotalImpOrigCluster := FTotalImpOrigCluster + anOpRecord.ImporteOrigOp;

    // para los cluster día
    if anOpRecord.RecType <> 'DEV' then
    begin
      if anOpRecord.OpNat = '1' then
      begin
        FTotalImpPrinCobroOpSop := FTotalImpPrinCobroOpSop + anOpRecord.ImportePrinOp;
        FTotalImpOrigCobroOpSop := FTotalImpOrigCobroOpSop + anOpRecord.ImporteOrigOp;
        
        FTotalImpPrinCobroOpDia := FTotalImpPrinCobroOpDia + anOpRecord.ImportePrinOp;
        FTotalImpOrigCobroOpDia := FTotalImpOrigCobroOpDia + anOpRecord.ImporteOrigOp;
      end
      else
      begin
        FTotalImpPrinPagosOpSop := FTotalImpPrinPagosOpSop + anOpRecord.ImportePrinOp;
        FTOtalImpOrigPagosOpSop := FTotalImpOrigPagosOpSop + anOpRecord.ImporteOrigOp;

        FTotalImpPrinPagosOpDia := FTotalImpPrinPagosOpDia + anOpRecord.ImportePrinOp;
        FTotalImpOrigPagosOpDia := FTotalImpOrigPagosOpDia + anOpRecord.ImporteOrigOp;
      end
    end
    else  // -- es un devolución
    begin
      if anOpRecord.OpNat = '1' then
      begin
        FTotalImpPrinCobroDevSop := FTotalImpPrinCobroDevSop + anOpRecord.ImportePrinOp;
        FTotalImpOrigCobroDevSop := FTotalImpOrigCobroDevSop + anOpRecord.ImporteOrigOp;

        FTotalImpPrinCobroDevDia := FTotalImpPrinCobroDevDia + anOpRecord.ImportePrinOp;
        FTotalImpOrigCobroDevDia := FTotalImpOrigCobroDevDia + anOpRecord.ImporteOrigOp;
      end
      else
      begin
        FTotalImpPrinPagosDevSop := FTotalImpPrinPagosDevSop + anOpRecord.ImportePrinOp;
        FTOtalImpOrigPagosDevSop := FTotalImpOrigPagosDevSop + anOpRecord.ImporteOrigOp;

        FTotalImpPrinPagosDevDia := FTotalImpPrinPagosDevDia + anOpRecord.ImportePrinOp;
        FTotalImpOrigPagosDevDia := FTotalImpOrigPagosDevDia + anOpRecord.ImporteOrigOp;
      end
    end;
  end;

  procedure TListadoTipoOpAgent.printSopHeadCluster(aCluster: TClusterNode);
  begin
    FListado.Add(' REF. SOPORTE: ' + aCluster.FSoporte);
    FListado.Add(EmptyStr);
  end;

  procedure TListadoTipoOpAgent.printSopFootCluster(aCluster: TClusterNode);
  begin
    FListado.Add(AddCharR(' ',' TOTAL REF SOPORTE ' + AddChar(' ',aCluster.FSoporte, 12)
        + ' ........ OPERACIONES - COBROS ', FSpacesToImporte )
        + AddChar(' ', FloatToStrF(FTotalImpPrinCobroOpSop, ffNumber, 15, 2) + ' €', 18)
        + '  ' + AddChar(' ', FloatToStrF(FTotalImpOrigCobroOpSop, ffNumber, 15, 0) + ' Pt', 18) );
    FListado.Add(AddCharR(' ', MS(' ', 55) + 'PAGOS ', FSpacesToImporte)
        + AddChar(' ', FloatToStrF(FTotalImpPrinPagosOpSop, ffNumber, 15, 2) + ' €', 18)
        + '  ' +  AddChar(' ', FloatToStrF(FTotalImpOrigPagosOpSop, ffNumber, 15, 0) + ' Pt', 18) );
    FListado.Add(AddCharR(' ', MS(' ', 40) + 'DEVOLUCIONES - COBROS ', FSpacesToImporte)
        + AddChar(' ', FloatToStrF(FTotalImpPrinCobroDevSop, ffNumber, 15, 2) + ' €', 18)
        + '  ' + AddChar(' ', FloatToStrF(FTotalImpOrigCobroDevSop, ffNumber, 15, 0) + ' Pt', 18) );
    FListado.Add(AddCharR(' ', MS(' ', 55) + 'PAGOS ', FSpacesToImporte)
        + AddChar(' ', FloatToStrF(FTotalImpPrinPagosDevSop, ffNumber, 15, 2) + ' €', 18)
        + '  ' + AddChar(' ', FloatToStrF(FTotalImpOrigPagosDevSop, ffNumber, 15, 0) + ' Pt', 18) );
    FListado.Add(EmptyStr);
  end;

  procedure TListadoTipoOpAgent.printFechaCluster(aCluster: TClusterNode);
  begin
    FListado.Add(' FECHA: ' + formatDateTime('dd/mm/yyyy', aCluster.FDate) );
    FListado.Add(EmptyStr);
  end;

  procedure TListadoTipoOpAgent.printFechaFootCluster(aCluster: TClusterNode);
  begin
    FListado.Add(AddCharR(' ',' TOTAL FECHA ' + formatDateTime('dd/mm/yyyy', aCluster.FDate)
        + ' ........... OPERACIONES - COBROS ', FSpacesToImporte )
        + AddChar(' ', FloatToStrF(FTotalImpPrinCobroOpDia, ffNumber, 15, 2) + ' €', 18)
        + '  ' + AddChar(' ', FloatToStrF(FTotalImpOrigCobroOpDia, ffNumber, 15, 0) + ' Pt', 18) );
    FListado.Add(AddCharR(' ', MS(' ', 50) + 'PAGOS ', FSpacesToImporte)
        + AddChar(' ', FloatToStrF(FTotalImpPrinPagosOpDia, ffNumber, 15, 2) + ' €', 18)
        + '  ' +  AddChar(' ', FloatToStrF(FTotalImpOrigPagosOpDia, ffNumber, 15, 0) + ' Pt', 18) );
    FListado.Add(AddCharR(' ', MS(' ', 35) + 'DEVOLUCIONES - COBROS ', FSpacesToImporte)
        + AddChar(' ', FloatToStrF(FTotalImpPrinCobroDevDia, ffNumber, 15, 2) + ' €', 18)
        + '  ' + AddChar(' ', FloatToStrF(FTotalImpOrigCobroDevDia, ffNumber, 15, 0) + ' Pt', 18) );
    FListado.Add(AddCharR(' ', MS(' ', 50) + 'PAGOS ', FSpacesToImporte)
        + AddChar(' ', FloatToStrF(FTotalImpPrinPagosDevDia, ffNumber, 15, 2) + ' €', 18)
        + '  ' + AddChar(' ', FloatToStrF(FTotalImpOrigPagosDevDia, ffNumber, 15, 0) + ' Pt', 18) );
    FListado.Add(EmptyStr);
  end;

  procedure TListadoTipoOpAgent.printTermCluster(aCluster: TClusterNode);
  begin
    FListado.Add(' TERMINAL: ' + aCluster.FTerminal );
    FListado.Add(EmptyStr);
  end;

  procedure TListadoTipoOpAgent.printRecTypeCluster(aCluster: TClusterNode);
  var
    lineaOp: String;
  begin
    if aCluster.FRecType = 'DEV' then
      lineaOp := 'DEV - DEVOLUCIONES.'
    else
      lineaOp := aCluster.FRecType + ' - ' + FOpNames[strToInt(aCluster.FRecType)];
    FListado.Add(' TIPO OPERACION: ' + lineaOp );
    FListado.Add(EmptyStr);
  end;

  procedure TListadoTipoOpAgent.printOpNatCluster(aCluster: TClusterNode);
  begin
    if aCluster.FOpNat = '1'  then
      FListado.Add(' COBROS')
    else
      FListado.Add(' PAGOS');
    FListado.Add(EmptyStr);
  end;

  procedure TListadoTipoOpAgent.printGenColsHead;
  var
    lineaCol: String;
  begin
    lineaCol := ' ';
    if not FParams.dateSeparation() then
      lineaCol := lineaCol + AddCharR(' ', 'FECHA', 10);
    if not FParams.typeSeparation() then
    begin
      if trim(lineaCol) <> EmptyStr then
        lineaCol := lineaCol + '  ';
      lineaCol := lineaCol + AddCharR(' ', 'TIPO', 6);
    end;
    if not FParams.termSeparation() then
    begin
      if trim(lineaCol) <> EmptyStr then
        lineaCol := lineaCol + '  ';
      lineaCol := lineaCol + 'TERMINAL';
    end;
    if trim(lineaCol) <> EmptyStr then
      lineaCol := lineaCol + '  ';
    lineaCol := lineaCol + AddCharR(' ', 'REFERENCIA', 16)
                         + '  '
                         + AddCharR(' ', 'ENT.OFI. DEST', 14)
                         + '  '
                         + AddCharR(' ', 'NUM.CTA.', 14)
                         + '  ';
    FSpacesToImporte := Length(lineaCol);
    lineaCol := lineaCol + AddChar(' ', 'IMP.PRINCIPAL', 18)
                         + '  '
                         + AddChar(' ', 'IMP.ORIGINAL', 18);
    if FParams.indicateSopAsCol() then
      lineaCol := lineaCol + '  ' + AddCharR(' ', 'REF. SOPORTE', 12);
    FWidthCols := Length(lineaCol);
    FListado.Add(lineaCol);
  end;

  procedure TListadoTipoOpAgent.printGenSepColsHead;
  begin
    FListado.Add(' ' + MS('_', FWidthCols - 1));
  end;

  procedure TListadoTipoOpAgent.printSpecificColsHead(aRecType: String);
  var
    lineaCol: String;
  begin
    if aRecType = '01' then
    begin
      // -- en principio descartado
    end
    else if aRecType = '02' then
    begin
      lineaCol := '   TIPO DOCUMENTO                  CLÁUSULA DE GASTOS    NÚM.DOCUMENTO  CLAVE CTA.ABONO   JUSTIF.COBRO.EXT.';
//                    ....5....5....5....5....5....5  ....5....5....5....5  ....5....5..   ....5....5....5.  ....5....5....5..
      if FWidthCols < Length(lineaCol) then FWidthCols := Length(lineaCol);
      FListado.Add(lineaCol);
      lineaCol := '   PRESTCN.PARCIAL     IMPORTE ORIGINAL  PROVINCIA TOMADORA            ';
//                    ....5....5....5   ....5....5....5...  ....5....5....5....5....5....5
      if FWidthCols < Length(lineaCol) then FWidthCols := Length(lineaCol);
      FListado.Add(lineaCol);
    end
    else if aRecType = '03' then
    begin
    end
    else if aRecType = '04' then
    begin
    end
    else if aRecType = '05' then
    begin
    end
    else if aRecType = '06' then
    begin
    end
    else if aRecType = '07' then
    begin
    end
    else if aRecType = '08' then
    begin
    end
    else if aRecType = '09' then
    begin
    end
    else if aRecType = '10' then
    begin
    end
    else if aRecType = '11' then
    begin
    end
    else if aRecType = '12' then
    begin
    end
    else if aRecType = '13' then
    begin
    end
    else if aRecType = '14' then
    begin
    end
    else if aRecType = 'DEV' then
    begin
    end
  end;

  procedure TListadoTipoOpAgent.printColsHead(aRecType: String);
  begin
    printGenColsHead();
    // -- aquí es dónde se debe imprimir el resto de los datos (los campos)
    if FParams.addTypeInfo() then
      printSpecificColsHead(aRecType);
    printGenSepColsHead();
  end;

  procedure TListadoTipoOpAgent.printColsFoot;
  var
    lineaSep: String;
  begin
(*
    lineaSep := ' ';
    if not FParams.dateSeparation() then
      lineaSep := lineaSep + MS(' ', 10);
    if not FParams.typeSeparation() then
    begin
      if not FParams.dateSeparation() then
        lineaSep := lineaSep + '  ';
      lineaSep := lineaSep + MS(' ', 6);
    end;
    if not FParams.termSeparation() then
    begin
      if not FParams.dateSeparation() or not FParams.typeSeparation() then
        lineaSep := lineaSep + '  ';
      lineaSep := lineaSep + MS(' ', 8);
    end;
    if not FParams.dateSeparation() or not FParams.termSeparation() then
      lineaSep := lineaSep + '  ';
    // terminamos de separar...
    lineaSep := lineaSep + MS(' ', 16)
                         + '  '
                         + MS(' ', 14)
                         + '  '
                         + MS(' ', 14)
                         + '  ';
*)
    lineaSep := MS(' ', FSpacesToImporte);

    FListado.Add(lineaSep + MS('_', 18) + '  ' + MS('_', 18));
    FListado.Add(lineaSep + AddChar(' ', FloatToStrF(FTotalImpPrinCluster, ffNumber, 15, 2) + ' €', 18)
          + '  ' + AddChar(' ', FloatToStrF(FTotalImpOrigCluster, ffNumber, 15, 0) + ' Pt', 18) );
    FListado.Add(EmptyStr);
    if FParams.newPageAfter() then
      FListado.Add('<SALTO-PAGINA>')
    else
    begin
      FListado.Add(EmptyStr);
      FListado.Add(EmptyStr);
    end;
  end;

  procedure TListadoTipoOpAgent.printGenRecordData(aOpRecord: TOpDivSystemRecord);
  var
    lineaRec: String;
  begin
    lineaRec := ' ';
    if not FParams.dateSeparation() then
      lineaRec := lineaRec + formatDateTime('dd/mm/yyyy', aOpRecord.DateCreation);
    if not FParams.typeSeparation() then
    begin
      if trim(lineaRec) <> EmptyStr then
        lineaRec := lineaRec + '  ';
      if aOpRecord.RecType <> 'DEV' then
        lineaRec := lineaRec + '  ' + aOpRecord.RecType + '  '
      else
        lineaRec := lineaRec + 'DEV-' + TOpDivRecTypeDEV(aOpRecord).TipoOpOriginal;
    end;
    if not FParams.termSeparation() then
    begin
      if trim(lineaRec) <> EmptyStr then
        lineaRec := lineaRec + '  ';
      lineaRec := lineaRec + AddChar(' ', aOpRecord.StationID, 8);
    end;
    if trim(lineaRec) <> EmptyStr then
      lineaRec := lineaRec + '  ';

    lineaRec := lineaRec + AddCharR('0', aOpRecord.OpRef, 16 )
                         + '  '
                         + AddCharR(' ', copy(aOpRecord.EntOficDestino, 1, 4) + '-' + copy(aOpRecord.EntOficDestino, 5, 4) + '-' + aOpRecord.DCEntOficDestino, 14)
                         + '  '
                         + AddCharR(' ', aOpRecord.DCNumCtaDestino + '-' + aOpRecord.NumCtaDestino, 14)
                         + '  '
                         + AddChar(' ', FloatToStrF(aOpRecord.ImportePrinOp, ffNumber, 15, 2) + ' €', 18)
                         + '  '
                         + AddChar(' ', FloatToStrF(aOpRecord.ImporteOrigOp, ffNumber, 15, 0) + ' Pt', 18);
    if FParams.indicateSopAsCol() then
    begin
      lineaRec := lineaRec + '  ' + aOpRecord.Soporte;
    end;
    FListado.Add(lineaRec);
  end;

  procedure TListadoTipoOpAgent.printType02RecordData(anType02Record: TOpDivRecType02);
  var
    lineaRec,
    auxData: String;
  begin
    // -- tipo documento
    if anType02Record.TipoDocumento = '01' then
      auxData := '01 - NORMALIZADO'
    else if anType02Record.TipoDocumento = '02' then
      auxData := '02 - NO NORMALIZADO'
    else if anType02Record.TipoDocumento = '03' then
      auxData := '03 - SOLICT.ABONO CON GARANTÍA'
    else if anType02Record.TipoDocumento = '04' then
      auxData := '04 - VALES CARBURANTE';
    lineaRec := '   ' + AddCharR(' ', Copy(auxData, 1, 30), 30);
    // -- Cláusula de gastos
    if anType02Record.ClausulaGastos = '0' then
      auxData := '0 - SIN DECLARACIÓN'
    else if anType02Record.ClausulaGastos = '1' then
      auxData := '1 - CON DECLARACIÓN'
    else if anType02Record.ClausulaGastos = '2' then
      auxData := '2 - PROTESTO NOTARIAL';
    lineaRec := lineaRec + '  ' + AddCharR(' ', Copy(auxData, 1, 20), 20);
    // -- Número de documento
    if ReplaceStr(anType02Record.NumDocumento, '0', '') = EmptyStr then
      auxData := MS(' ', 13)
    else
      auxData := AddChar('0', anType02Record.NumDocumento, 12) + ' ';
    lineaRec := lineaRec + '  ' + auxData;
    // -- clave cuenta
    if anType02Record.Residente then
      auxData := '1 - RESIDENTE'
    else
      auxData := '2 - NO RESIDENTE';
    lineaRec := lineaRec + '  ' + AddCharR(' ', auxData, 16);
    // -- justificación de cobro del exterior
    if anType02Record.JustificaCobroExt then
      auxData := '1 - SÍ'
    else
      auxData := '2 - NO';
    lineaRec := lineaRec + '  ' + MS(' ', 5) + auxData;

    FListado.Add(lineaRec);

    // -- presentación parcial
    if anType02Record.PresentaParcial then
      auxData := '1 - SÍ'
    else
      auxData := '2 - NO';
    lineaRec := '   ' + auxData + MS(' ', 9);
    // -- importe original
    if anType02Record.ImporteOriginal = 0.0 then
      auxData := EmptyStr
    else
      auxData := FloatToStrF(anType02Record.ImporteOriginal, ffNumber, 15, 2) + ' €';
    lineaRec := lineaRec + '  ' + AddChar(' ', auxData, 18);
    // -- provincia tomadora
    if theQueryEngine.existsProvincia(anType02Record.ProvinciaTomadora) then
      auxData := anType02Record.ProvinciaTomadora + ' - ' + theQueryEngine.getProvinciaName(anType02Record.ProvinciaTomadora)
    else
      auxData := EmptyStr;
    lineaRec := lineaRec + '  ' + AddCharR(' ', Copy(auxData, 1, 30), 30);

    FListado.Add(lineaRec);
  end;

  procedure TListadoTipoOpAgent.printSpecificRecordData(anOpRecord: TOpDivSystemRecord);
  begin
    if      anOpRecord.RecType = '01' then
      // -- por el momento nada
    else if anOpRecord.RecType = '02' then
      printType02RecordData(TOpDivRecType02(anOpRecord));
  end;

  procedure TListadoTipoOpAgent.printRecordData(aOpRecord: TOpDivSystemRecord);
  begin
    printGenRecordData(aOpRecord);
    if FParams.addTypeInfo() then
      printSpecificRecordData(aOpRecord);
  end;

  procedure TListadoTipoOpAgent.doPrintCluster(aCluster: TClusterNode);
  var
    numCluster: Integer;
  begin
    case aCluster.FNodeType of
      cntSoporte: begin
                    printSopHeadCluster(aCluster);
                    startSopClusterSum();
                  end;
      cntDate: begin
                 printFechaCluster(aCluster);
                 startDateClusterSum();
               end;
      cntTerm: printTermCluster(aCluster);
      cntRec:  printRecTypeCluster(aCluster);
      cntNat:  printOpNatCluster(aCluster);
    end;

    if aCluster.FNodeType = cntNat then
    begin
      startClusterSum();
      printColsHead(aCluster.FRecType);
    end;

    for numCluster := 0 to aCluster.FListClusters.Count - 1 do
      if aCluster.FNodeType <> cntNat then
        doPrintCluster(TClusterNode(aCluster.FListClusters.Items[numCluster]))
      else
      begin
        // se trata de un registro de operación que hay que imprimir
        printRecordData(TOpDivSystemRecord(aCluster.FListClusters.Items[numCluster]));
        // y sumamos los valores a los acumuladores
        addClusterSum(TOpDivSystemRecord(aCluster.FListClusters.Items[numCluster]));
      end;

    case aCluster.FNodeType of
      cntSoporte: printSopFootCluster(aCluster);
      cntDate: printFechaFootCluster(aCluster);
      cntNat:  printColsFoot();
    end;
  end;

  procedure TListadoTipoOpAgent.doShowListView;
  var
    showForm: TShowListadoTextForm;
  begin
    showForm := TShowListadoTextForm.Create(nil);
    try
      showForm.listadoMemo.Lines.Assign(FListado);
      showForm.ShowModal();
    finally
      showForm.Free();
    end;
  end;

  procedure TListadoTipoOpAgent.doList();
  var
    numRecord: Integer;
  begin
    // se le coloca a falso pq se van a "mover" los registros hacia otras listas
    // que serán las responsables de eliminarlos después
    FListaRegs.OwnsObjects := false;

    // se crea el cluster principal
    FMainCluster := TClusterNode.Create();
    try
      // se añaden los registros a los clusters oportunos
      for numRecord := 0 to FListaRegs.Count - 1 do
        FMainCluster.insertRecord(FParams, TOpDivSystemRecord(FListaRegs.Items[numRecord]));

      // ahora se procesa el árbol de clústers para generar el resultado
      doPrintCluster(FMainCluster);

      // mostramos el resultado en una ventana...
      doShowListView();
    finally
      FMainCluster.Free();
    end;
  end;

  //*****************
  // MÉTODOS PÚBLICOS
  //*****************

  Constructor TListadoTipoOpAgent.Create;
  begin
    inherited;
    FParams := nil;
    FListado := TStringList.Create;

    FOpNames[ 1] := 'EFECTOS';
    FOpNames[ 2] := 'CHEQUES';
    FOpNames[ 3] := 'REG. OP. SIST. INTERCAMBIO. DOCUMENTAL';
    FOpNames[ 4] := 'REG. OP. SIST. INTERCAMBIO. NO DOCUMENTAL';
    FOpNames[ 5] := 'ACTAS DE PROTESTO';
    FOpNames[ 6] := 'COMISIONES Y GASTOS DE CRÉDITOS Y/O REMESAS DOC.';
    FOpNames[ 7] := 'PAGOS EN NOTARÍA';
    FOpNames[ 8] := 'CESIONES DE EFECTIVO';
    FOpNames[ 9] := 'COMPRAVENTA DE MONEDA EXTRANJERA';
    FOpNames[10] := 'REEMBOLSOS';
    FOpNames[11] := 'REGULARIZACIÓN DESFASES TESOREROS';
    FOpNames[12] := 'COMISIONES';
    FOpNames[13] := 'RECUPERACIÓN DE COMISIONES Y/O INTERESES DE LOS SUBSISTEMAS DE INTERC.';
    FOpNames[14] := 'OTRAS OPERACIONES';
    FOpNames[TIPO_OP_PARAM_DEVOLUCION_INDEX] := 'DEVOLUCIONES';

//    FListaRegs := TObjectList.Create();
  end;

  Constructor TListadoTipoOpAgent.CreateWithParams(aParams: TListadoTipoOpParams);
  begin
    Self.Create();
    FParams := aParams;
  end;

  Destructor  TListadoTipoOpAgent.Destroy;
  begin
    FListado.Free();
    if assigned(FListaRegs) then FListaRegs.Free();
    inherited;
  end;

  procedure TListadoTipoOpAgent.Execute;
  begin
    // obtenemos los registros de forma ordenada.
    getOpList();
    // entonces los recorremos, buscando los que entran dentro del rango de fechas
    doList();
  end;

  procedure TListadoTipoOpAgent.ExecuteWithParams(aParams: TListadoTipoOpParams);
  begin
    setParams(aParams);
    Execute();
  end;

  procedure TListadoTipoOpAgent.setParams(aParams: TListadoTipoOpParams);
  begin
    if assigned(FParams) then
      FParams.Free();
    FParams := aParams;
  end;

end.
