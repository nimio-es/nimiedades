unit CListadosAgent;

interface

  uses
    SysUtils,
    Dialogs,
    Forms,
    VSelListadoForm,
    VSelTipoOpListadoForm;

  type
    TListadosAgent = class(TObject)
      protected
        FSelForm: TSelListadoForm;
        FSelTipoOpForm: TSelTipoOpListadoForm;

        //*** respuesta a eventos de los formularos asociados
        // -- del de selección
        procedure selFormAceptarBtn(Sender: TObject);
        procedure selFormCancelarBtn(Sender: TObject);
        // -- opciones del listado por tipos de operación
        procedure selTipoOpAceptarBtn(Sender: TObject);
        procedure selTipoOpCancelarBtn(Sender: TObject);

        procedure ShowSeleccion; virtual;
        procedure ShowTipoOpSeleccion; virtual;
        procedure ShowSoportesSeleccion; virtual;
      public
        procedure Execute; virtual;
    end;

implementation

  uses
    CListadoTipoOpAgent;

(**************
  MÉTODOS PROTEGIDOS
 **************)

 // **** respuestas a los eventos de los formularios
 procedure TListadosAgent.selFormAceptarBtn(Sender: TObject);
 begin
   if FSelForm.tiposOperacionesRadioButton.Checked then
     ShowTipoOpSeleccion()
   else
     ShowSoportesSeleccion();
 end;

 procedure TListadosAgent.selFormCancelarBtn(Sender: TObject);
 begin
   FSelForm.Close();
 end;

 // --

 procedure TListadosAgent.selTipoOpAceptarBtn(Sender: TObject);
 var
   listadoParams: TListadoTipoOpParams;
   listadoAgent : TListadoTipoOpAgent;
   numTipo: Integer;
 begin
   listadoParams := TListadoTipoOpParams.Create();
   listadoAgent  := TListadoTipoOpAgent.Create();
   try
     listadoParams.FFechas[TIPO_OP_PARAM_FECHA_DESDE_INDEX] := FSelForm.fechaDesdeEdit.Date;
     listadoParams.FFechas[TIPO_OP_PARAM_FECHA_HASTA_INDEX] := FSelForm.fechaHastaEdit.Date;
     listadoParams.FInidicarSoporte      := FSelTipoOpForm.indicarSoporteEnvioCheckBox.Checked;
     listadoParams.FSepararPorSoporte    := FSelTipoOpForm.separarPorSoporteCheckBox.Checked;
     listadoParams.FSepararPorFechas     := FSelTipoOpForm.separarDiasCheckBox.Checked;
     listadoParams.FSepararPorTerminales := FSelTipoOpForm.separarTerminalesCheckBox.Checked;
     listadoParams.FSepararPorTipos      := FSelTipoOpForm.separarTiposCheckBox.Checked;
     listadoParams.FAnadirDatosCadaTipo  := FSelTipoOpFOrm.anadirDatosEspecificosOpCheckBox.Checked;
     listadoParams.FSoloIncluirTipos     := FSelTipoOpForm.incluirSoloTiposCheckBox.Checked;
     listadoParams.FSaltarPagina         := FSelTipoOpForm.saltoPaginaCheckBox.Checked;
     listadoParams.FEmitirCuadorResumen  := FSelTipoOpForm.emitirResumenCheckBox.Checked;
     for numTipo := 0 to FSelTipoOpForm.tiposAIncluirCheckListBox.Count - 1 do
       listadoParams.FTiposAIncluir[numTipo + 1] := FSelTipoOpForm.tiposAIncluirCheckListBox.Checked[numTipo];

     listadoAgent.ExecuteWithParams(listadoParams);
   finally
     listadoParams.Free();
     listadoAgent.Free();
   end
 end;

 procedure TListadosAgent.selTipoOpCancelarBtn(Sender: TObject);
 begin
   FSelTipoOpForm.Close();
 end;

 // ****

 procedure TListadosAgent.ShowSeleccion;
 begin
   FSelForm := TSelListadoForm.Create(nil);
   try
     FSelForm.fechaDesdeEdit.Date := date();
     FSelForm.fechaHastaEdit.Date := date();

     FSelForm.AceptarButton.OnClick  := selFormAceptarBtn;
     FSelForm.CancelarButton.OnClick := selFormCancelarBtn;
     FSelForm.ShowModal();
   finally
     FSelForm.Free();
   end;
 end;

 procedure TListadosAgent.ShowTipoOpSeleccion;
 var
   variosDias: Boolean;
   addCabStr: String;
 begin
   FSelTipoOpForm := TSelTipoOpListadoForm.Create(nil);
   try
     variosDias := (FSelForm.fechaDesdeEdit.Date <> FSelForm.fechaHastaEdit.Date);
     addCabStr := dateToStr( FSelForm.fechaDesdeEdit.Date );
     if variosDias then
       addCabStr :=  addCabStr + ' a ' + dateToStr( FSelForm.fechaHastaEdit.Date );
     FSelTipoOpForm.LabelCabecera.Caption := FSelTipoOpForm.LabelCabecera.Caption + ' (' + addCabStr + ')';
     FSelTipoOpForm.separarDiasCheckBox.Enabled := variosDias;

     FSelTipoOpForm.AceptarBtn.OnClick  := selTipoOpAceptarBtn;
     FSelTipoOpForm.CancelarBtn.OnClick := selTipoOpCancelarBtn;
     
     FSelTipoOpForm.ShowModal();
   finally
     FSelTipoOpForm.Free();
   end;
 end;

 procedure TListadosAgent.ShowSoportesSeleccion;
 begin
 end;

(**************
  MÉTODOS PÚBLICOS
 **************)

 procedure TListadosAgent.Execute;
 begin
   ShowSeleccion();
 end;

end.
