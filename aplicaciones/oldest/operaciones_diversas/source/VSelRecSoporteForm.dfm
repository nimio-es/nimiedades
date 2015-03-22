object SelRecSoporteForm: TSelRecSoporteForm
  Left = 229
  Top = 117
  Width = 727
  Height = 515
  Caption = 'Soportes (transmisiones)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    719
    488)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 16
    Top = 16
    Width = 36
    Height = 13
    Caption = 'Fecha :'
  end
  object FechaSoporteEdit: TDateEdit
    Left = 60
    Top = 12
    Width = 93
    Height = 18
    NumGlyphs = 2
    TabOrder = 6
    OnChange = FechaSoporteEditChange
  end
  object soportesListView: TListView
    Left = 0
    Top = 56
    Width = 719
    Height = 145
    Anchors = [akLeft, akTop, akRight]
    Columns = <
      item
        Caption = 'Tipo'
        Width = 120
      end
      item
        Caption = 'Estacion'
        Width = 60
      end
      item
        Caption = 'Hora'
        Width = 80
      end
      item
        Alignment = taCenter
        Caption = 'Num. Orden'
        Width = 70
      end
      item
        Alignment = taRightJustify
        Caption = 'Importe'
        Width = 100
      end
      item
        Alignment = taCenter
        Caption = 'Num. Regs.'
        Width = 80
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 7
    ViewStyle = vsReport
    OnSelectItem = soportesListViewSelectItem
  end
  object Panel2: TPanel
    Left = 0
    Top = 38
    Width = 719
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Soportes'
    TabOrder = 8
  end
  object Panel1: TPanel
    Left = 0
    Top = 202
    Width = 719
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Registros'
    TabOrder = 9
  end
  object newButton: TButton
    Left = 0
    Top = 436
    Width = 75
    Height = 25
    Caption = 'Nuevo'
    TabOrder = 0
  end
  object modifyButton: TButton
    Left = 80
    Top = 436
    Width = 75
    Height = 25
    Caption = 'Modificar'
    Enabled = False
    TabOrder = 1
  end
  object delSoporteButton: TButton
    Left = 160
    Top = 436
    Width = 75
    Height = 25
    Caption = 'Eliminar'
    Enabled = False
    TabOrder = 2
  end
  object genSopButton: TButton
    Left = 264
    Top = 436
    Width = 97
    Height = 25
    Caption = 'Generar fichero'
    Enabled = False
    TabOrder = 3
  end
  object TerminarBtn: TButton
    Left = 640
    Top = 436
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Terminar'
    TabOrder = 5
    OnClick = TerminarBtnClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 469
    Width = 719
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object vinculadosListView: TListView
    Left = 0
    Top = 223
    Width = 717
    Height = 202
    Anchors = [akLeft, akTop, akRight]
    Color = clBtnFace
    Columns = <
      item
        Caption = 'Referencia'
        Width = 115
      end
      item
        Caption = 'Tipo'
        Width = 35
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
    TabOrder = 11
    ViewStyle = vsReport
  end
  object prnSopButton: TButton
    Left = 368
    Top = 436
    Width = 73
    Height = 25
    Caption = 'Imprimir'
    Enabled = False
    TabOrder = 4
  end
end
