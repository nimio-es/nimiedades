object OpenRecord: TOpenRecord
  Left = 183
  Top = 195
  BorderStyle = bsDialog
  Caption = 'Leer...'
  ClientHeight = 307
  ClientWidth = 644
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object panelBotones: TPanel
    Left = 0
    Top = 277
    Width = 644
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      644
      30)
    object btnAceptar: TButton
      Left = 484
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight]
      Caption = '&Aceptar'
      Default = True
      TabOrder = 0
      OnClick = btnAceptarClick
    end
    object btnCancelar: TButton
      Left = 564
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight]
      Cancel = True
      Caption = '&Cancelar'
      ModalResult = 7
      TabOrder = 1
    end
    object panelBloqueo: TPanel
      Left = 8
      Top = 4
      Width = 257
      Height = 21
      Caption = 'Bloqueo general de registros'
      Color = clRed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clYellow
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Visible = False
    end
  end
  object RecordsListView: TListView
    Left = 0
    Top = 21
    Width = 644
    Height = 256
    Align = alClient
    Columns = <
      item
        Caption = 'Estaci'#243'n'
        Width = 55
      end
      item
        Caption = 'OID'
        Width = 150
      end
      item
        Caption = 'Fecha y hora'
        Width = 110
      end
      item
        Caption = 'Tipo'
        Width = 35
      end
      item
        Caption = 'Naturaleza'
        Width = 60
      end
      item
        Caption = 'Ent/Ofi. Dest.'
        Width = 65
      end
      item
        Alignment = taRightJustify
        Caption = 'Importe Prin.'
        Width = 80
      end
      item
        Caption = 'Divisa Op.'
        Width = 40
      end
      item
        Caption = 'Incluir Sop.'
        Width = 40
      end
      item
        Caption = 'Descripci'#243'n'
        Width = 200
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = RecordsListViewColumnClick
    OnCompare = RecordsListViewCompare
  end
  object panelFiltro: TPanel
    Left = 0
    Top = 0
    Width = 644
    Height = 21
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      644
      21)
    object mostrarVinculadosCheckBox: TCheckBox
      Left = 472
      Top = 4
      Width = 169
      Height = 17
      Alignment = taLeftJustify
      Anchors = [akTop, akRight]
      Caption = 'Mostrar vinculados a soportes :'
      TabOrder = 0
      OnClick = mostrarVinculadosCheckBoxClick
    end
  end
end
