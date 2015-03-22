unit CPrintOpAgent;

(*******************************************************************************
 * CLASE: TPrintOpAgent                                                        *
 * FECHA CREACION: 08-2001                                                     *
 * PROGRAMADOR: Saulo Alvarado Mateos                                          *
 * DESCRIPCIÓN:                                                                *                                                                              *
 *       Agente encargado de gestionar la impresión de un registro concreto,   *
 * mostrando el resultado en una ventana.                                      *
 *                                                                             *
 * FECHA MODIFICACIÓN: 08-05-2002                                              *
 * PROGRAMADOR: Saulo Alvarado Mateos (CINCA)                                  *
 * DESCRIPCIÓN:                                                                *
 *       Se añade una opción para que el usuario pueda elegir el número de co- *
 * pias a imprimir de una sola vez. Esto evita la molestia de tener que leer   *
 * el registro para imprimirlo N veces. Se pone un tope máximo (a nivel del    *
 * propio control en tiempo de diseño) de 99.                                  *
 *******************************************************************************)

interface

  uses
    SysUtils,
    Classes,
    Controls,
    COpDivSystemRecord,
    VShowListadoText;

  type

    TPrintOpAgent = class(TObject)
      protected
        FOperation:  TOpDivSystemRecord;
        FPrnStrings: TStringList;
        FShowPrint:  TShowListadoTextForm;

        FNumCopias: Integer;

        // procedimientos asociados a eventos en la vista
        procedure onChangeNumCopias(Sender: TObject);
        procedure onClickImprimirBtn(Sender: TObject);

        procedure doPrintRec; virtual;
        procedure doShowPrint; virtual;
      public
        constructor Create; virtual;
        destructor  Destroy; override;

        procedure Execute(anOp: TOpDivSystemRecord);
    end;

implementation

  uses
    StdCtrls,
    Printers;

(******************
 MÉTODOS PROTEGIDOS
 ******************)

 procedure TPrintOpAgent.onChangeNumCopias(Sender: TObject);
 begin
   FNumCopias := StrToInt(TEdit( Sender ).Text);
 end;

 procedure TPrintOpAgent.onClickImprimirBtn(Sender: TObject);
 begin
   doPrintRec();
 end;

 procedure TPrintOpAgent.doPrintRec;
 var
//   Impresion: TEXT;
   iLine: Integer;
   xPos, yPos: Integer;
   // 08.05.02 - se pueden imprimir N copias de una vez
   numCopia: Integer;
 begin
(* $ 5/11/2001 -- a partir de ahora, se manipula la impresión "pintando" en vez de
     enviando las líneas.

   AssignPrn(Impresion);
   Rewrite(Impresion);
   // ponemos un tipo de letra que sea FIXED
//   Printer.Canvas.Font.Name := 'Courier New';
//   Printer.Canvas.Font.Size := 9;

   for iLine := 0 to FPrnStrings.Count - 1 do
     WriteLn(Impresion, FPrnStrings.Strings[iLine]);
   CloseFile(Impresion);

*)

   for numCopia := 1 to FNumCopias do
   begin
     Printer.BeginDoc();
     printer.Title := 'Operaciones diversas. Tipo ' + FOperation.RecType;

     // establecemos fuente y tamaño
     Printer.Canvas.Font.Name := 'Courier New';
     Printer.Canvas.Font.Size := 10;

     // dejamos un margen de x píxeles y empezamos en y...
     xPos := 15;
     yPos := 65;
     for iLine := 0 to FPrnStrings.Count - 1 do
     begin
       Printer.Canvas.TextOut(xPos, yPos, FPrnStrings.Strings[iLine]);
       yPos := yPos + Printer.Canvas.TextHeight('0123456789abcdefghijklmnñopqrstuvwxzyABCDEFGHIJKLMNÑOPQRSTUVWXYZ_') + 3;
     end;

     Printer.EndDoc();
   end;

   // además, después de impreso se cierra la ventana
   FShowPrint.ModalResult := mrOK;
 end;

 procedure TPrintOpAgent.doShowPrint;
// var
//   showPrint: TShowListadoTextForm;
 begin
   FShowPrint := TShowListadoTextForm.Create(nil);
   try
     FShowPrint.listadoMemo.Lines.Assign(FPrnStrings);
     // 08.05.02 - se asocia el cambio de copias para tener "actualizado" el valor interno.
     FShowPrint.numCopiasEdit.OnChange := onChangeNumCopias;
     // se debe asociar el botón "imprimir"...
     FShowPrint.imprimirButton.OnClick := onClickImprimirBtn;
     FShowPrint.ShowModal();
   finally
     FShowPrint.Free();
   end;
 end;

(****************
 MÉTODOS PÚBLICOS
 ****************)

 // -- creación, destrucción

 constructor TPrintOpAgent.Create;
 begin
   inherited;

   FPrnStrings := TStringList.Create();
   FNumCopias := 0;
 end;

 destructor TPrintOpAgent.Destroy;
 begin
   FPrnStrings.Free();

   inherited;
 end;

 // -- de utilidad

 procedure TPrintOpAgent.Execute(anOp: TOpDivSystemRecord);
 begin
   FPrnStrings.Clear();

   FOperation := anOp;
   anOp.getDataAsPrintedRecord(FPrnStrings);

   doShowPrint();
 end;

end.
