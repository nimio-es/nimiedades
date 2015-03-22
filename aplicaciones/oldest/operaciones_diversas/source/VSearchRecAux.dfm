object SearchRecAuxForm: TSearchRecAuxForm
  Left = 240
  Top = 163
  Width = 658
  Height = 372
  ActiveControl = buscarEdit
  Caption = 'Buscar...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 308
    Width = 650
    Height = 37
    Align = alBottom
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      650
      37)
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 36
      Height = 13
      Caption = 'Buscar:'
    end
    object AceptarBtn: TButton
      Left = 491
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Aceptar'
      Default = True
      Enabled = False
      TabOrder = 0
      OnClick = AceptarBtnClick
    end
    object CancelarBtn: TButton
      Left = 571
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
    end
    object buscarEdit: TEdit
      Left = 52
      Top = 12
      Width = 425
      Height = 21
      TabOrder = 2
      OnChange = buscarEditChange
    end
  end
  object ElementsListView: TListView
    Left = 0
    Top = 0
    Width = 650
    Height = 308
    Align = alClient
    Columns = <
      item
        Caption = 'C'#243'digo'
      end
      item
        AutoSize = True
        Caption = 'Descripci'#243'n'
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = ElementsListViewColumnClick
    OnCompare = ElementsListViewCompare
    OnSelectItem = ElementsListViewSelectItem
  end
end
