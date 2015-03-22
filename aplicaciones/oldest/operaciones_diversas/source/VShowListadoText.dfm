object ShowListadoTextForm: TShowListadoTextForm
  Left = 226
  Top = 146
  Width = 693
  Height = 382
  Caption = 'Resultado del listado...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    685
    348)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 200
    Top = 324
    Width = 53
    Height = 13
    Caption = 'N'#186' Copias :'
  end
  object Panel1: TPanel
    Left = 8
    Top = 12
    Width = 670
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Listado (en modo texto)'
    TabOrder = 2
  end
  object listadoMemo: TMemo
    Left = 8
    Top = 28
    Width = 670
    Height = 285
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object terminarButton: TButton
    Left = 604
    Top = 320
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancelar'
    TabOrder = 3
    OnClick = terminarButtonClick
  end
  object imprimirButton: TButton
    Left = 520
    Top = 320
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Imprimir'
    TabOrder = 0
  end
  object selImpresoraButton: TButton
    Left = 8
    Top = 320
    Width = 125
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Seleccionar impresora...'
    TabOrder = 4
    TabStop = False
    OnClick = selImpresoraButtonClick
  end
  object numCopiasEdit: TMaskEdit
    Left = 260
    Top = 320
    Width = 31
    Height = 21
    EditMask = '##;0; '
    MaxLength = 2
    TabOrder = 5
    Text = '1'
  end
  object numCopiasUpDown: TUpDown
    Left = 293
    Top = 320
    Width = 16
    Height = 21
    Associate = numCopiasEdit
    Min = 1
    Max = 99
    Position = 1
    TabOrder = 6
    Wrap = False
  end
  object PrintDialog1: TPrintDialog
    Left = 104
    Top = 316
  end
end
