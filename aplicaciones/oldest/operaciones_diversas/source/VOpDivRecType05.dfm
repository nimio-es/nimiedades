inherited OpDivRecType05Form: TOpDivRecType05Form
  Left = 290
  Top = 195
  Width = 636
  Height = 431
  ActiveControl = OficinaOrigenEdit
  Caption = '05 - Actas de protesto'
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited registroLabel: TLabel
    Top = 356
    Width = 628
  end
  object Label6: TLabel [3]
    Left = 15
    Top = 148
    Width = 141
    Height = 26
    Caption = 
      'Identificaci'#243'n del subsistema'#13#10'de presentaci'#243'n inicial .........' +
      ' :'
  end
  object Label7: TLabel [4]
    Left = 212
    Top = 156
    Width = 382
    Height = 13
    Caption = 
      '( "0" = Desconocido; "1"= S.N.C.E. 004; "2"= S.N.C.E. 007; "3"= ' +
      'S.N.C.E. 008 )'
  end
  object Label8: TLabel [5]
    Left = 28
    Top = 192
    Width = 127
    Height = 13
    Caption = 'Ref. inicial del subsistema :'
  end
  object Label9: TLabel [6]
    Left = 16
    Top = 220
    Width = 138
    Height = 13
    Caption = 'Figura entidad presentadora :'
  end
  object Label10: TLabel [7]
    Left = 212
    Top = 220
    Width = 205
    Height = 13
    Caption = '( "1"= Tercera entidad; "2"= Domiciliataria )'
  end
  object Label11: TLabel [8]
    Left = 272
    Top = 260
    Width = 29
    Height = 13
    Caption = 'Libre :'
    Visible = False
  end
  inherited ClaveAutorizaLabel: TLabel
    Left = 52
    Top = 36
    Visible = False
  end
  inherited buscarEntidadSpeedButton: TSpeedButton
    Left = 504
  end
  inherited observacionesLabel: TLabel
    Left = 100
    Top = 252
  end
  inherited ReferencePanel: TPanel
    Width = 628
    TabOrder = 14
    inherited OpNatPanel: TPanel
      Width = 146
    end
    inherited DateCreationPanel: TPanel
      Left = 467
    end
  end
  inherited bottomPanel: TPanel
    Top = 369
    Width = 628
    TabOrder = 15
    inherited AceptarButton: TButton
      Left = 486
    end
    inherited CancelarButton: TButton
      Left = 566
    end
  end
  inherited cobroRadioBtn: TRadioButton
    TabOrder = 17
    Visible = False
  end
  inherited pagoRadioBtn: TRadioButton
    TabOrder = 16
    Visible = False
  end
  inherited EntidadOrigenEdit: TEdit
    TabOrder = 0
  end
  inherited OficinaOrigenEdit: TMaskEdit
    TabOrder = 1
  end
  object IdSubsistemaPresentaInicEdit: TMaskEdit [26]
    Left = 168
    Top = 152
    Width = 21
    Height = 21
    EditMask = '9;0; '
    MaxLength = 1
    TabOrder = 7
    OnExit = IdSubsistemaPresentaInicEditExit
  end
  object RefInicSubsEdit: TMaskEdit [27]
    Left = 168
    Top = 184
    Width = 109
    Height = 21
    EditMask = '9999999999999999;0; '
    MaxLength = 16
    TabOrder = 8
    Text = '0000000000000000'
    OnExit = RefInicSubsEditExit
  end
  object FigEntidadPresentaEdit: TMaskEdit [28]
    Left = 168
    Top = 216
    Width = 21
    Height = 21
    EditMask = '9;0; '
    MaxLength = 1
    TabOrder = 9
    OnExit = FigEntidadPresentaEditExit
  end
  object LibreEdit: TMemo [29]
    Left = 168
    Top = 272
    Width = 449
    Height = 5
    MaxLength = 220
    TabOrder = 12
    Visible = False
    OnExit = LibreEditExit
  end
  inherited EntidadOficinaDestinoEdit: TMaskEdit
    TabOrder = 2
  end
  inherited DivisaOperacionComboBox: TComboBox
    TabOrder = 4
  end
  inherited ImporteOrigenOperacionEdit: TRxCalcEdit
    TabOrder = 5
  end
  inherited ImportePrincipalOperacionEurosEdit: TEdit
    TabOrder = 6
  end
  inherited numCtaDestinoEdit: TMaskEdit
    TabOrder = 3
  end
  inherited claveAutorizaEdit: TMaskEdit
    Left = 168
    Top = 32
    TabOrder = 13
    Visible = False
  end
  inherited IncluirSoporteCheckBox: TCheckBox
    Left = 24
    Top = 328
    TabOrder = 11
  end
  inherited observacionesMemo: TMemo
    Left = 168
    Top = 252
    Width = 445
    TabOrder = 10
  end
end
