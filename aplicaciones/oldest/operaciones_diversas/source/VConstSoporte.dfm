object ConstSoporteForm: TConstSoporteForm
  Left = 224
  Top = 113
  BorderStyle = bsDialog
  Caption = 'Constituci'#243'n del soporte'
  ClientHeight = 536
  ClientWidth = 694
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 136
    Height = 13
    Caption = 'Fecha / N'#250'mero del soporte:'
  end
  object FechaSoporteEdit: TEdit
    Left = 168
    Top = 12
    Width = 93
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
    Text = '00/00/0000 - 001'
  end
  object disponiblesListView: TListView
    Left = 16
    Top = 96
    Width = 661
    Height = 181
    Columns = <
      item
        Caption = 'Estaci'#243'n'
        Width = 54
      end
      item
        Caption = 'Tipo'
        Width = 35
      end
      item
        Caption = 'Referencia'
        Width = 115
      end
      item
        Alignment = taCenter
        Caption = 'C/G'
      end
      item
        Caption = 'Ent-Ofi Dest.'
        Width = 70
      end
      item
        Caption = 'Fecha-Hora'
        Width = 125
      end
      item
        Alignment = taRightJustify
        Caption = 'Importe'
        Width = 90
      end>
    ColumnClick = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 3
    ViewStyle = vsReport
    OnSelectItem = disponiblesListViewSelectItem
  end
  object Panel1: TPanel
    Left = 16
    Top = 76
    Width = 661
    Height = 21
    Caption = 'Registros disponibles'
    TabOrder = 4
  end
  object documentalRadioButton: TRadioButton
    Left = 16
    Top = 46
    Width = 77
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Documental'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = documentalRadioButtonClick
  end
  object NoDocumentalRadioButton: TRadioButton
    Left = 108
    Top = 46
    Width = 93
    Height = 17
    Alignment = taLeftJustify
    Caption = 'No documental'
    TabOrder = 2
    OnClick = documentalRadioButtonClick
  end
  object Panel2: TPanel
    Left = 16
    Top = 320
    Width = 661
    Height = 21
    Caption = 'Registros vinculados al soporte'
    TabOrder = 5
  end
  object vinculadosListView: TListView
    Left = 16
    Top = 340
    Width = 661
    Height = 181
    Columns = <
      item
        Caption = 'Estaci'#243'n'
        Width = 54
      end
      item
        Caption = 'Tipo'
        Width = 35
      end
      item
        Caption = 'Referencia'
        Width = 115
      end
      item
        Alignment = taCenter
        Caption = 'C/G'
      end
      item
        Caption = 'Ent-Ofi Destino'
        Width = 70
      end
      item
        Caption = 'Fecha-Hora'
        Width = 125
      end
      item
        Alignment = taRightJustify
        Caption = 'Importe'
        Width = 90
      end>
    ColumnClick = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 6
    ViewStyle = vsReport
    OnSelectItem = vinculadosListViewSelectItem
  end
  object addButton: TButton
    Left = 16
    Top = 284
    Width = 75
    Height = 25
    Caption = 'A'#241'adir'
    Enabled = False
    TabOrder = 7
  end
  object addAllButton: TButton
    Left = 96
    Top = 284
    Width = 75
    Height = 25
    Caption = 'A'#241'adir todos'
    TabOrder = 8
  end
  object delButton: TButton
    Left = 224
    Top = 284
    Width = 75
    Height = 25
    Caption = 'Quitar'
    Enabled = False
    TabOrder = 9
  end
  object delAllButton: TButton
    Left = 304
    Top = 284
    Width = 75
    Height = 25
    Caption = 'Quitar todos'
    Enabled = False
    TabOrder = 10
  end
  object CancelarButton: TButton
    Left = 600
    Top = 284
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 11
  end
  object aceptarButton: TButton
    Left = 520
    Top = 284
    Width = 75
    Height = 25
    Caption = 'Aceptar'
    TabOrder = 12
  end
  object IncluirPendientesCheckBox: TCheckBox
    Left = 552
    Top = 52
    Width = 125
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Incluir los pendientes :'
    TabOrder = 13
  end
end
