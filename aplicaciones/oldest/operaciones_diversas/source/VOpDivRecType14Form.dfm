inherited OpDivRecType14Form: TOpDivRecType14Form
  Width = 646
  Height = 409
  Caption = '14 - Otras operaciones'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited registroLabel: TLabel
    Top = 334
    Width = 638
  end
  inherited ClaveAutorizaLabel: TLabel
    Left = 392
    Top = 28
    Visible = False
  end
  object Label1: TLabel [10]
    Left = 0
    Top = 188
    Width = 129
    Height = 13
    Caption = 'Concepto complementario :'
  end
  inherited buscarEntidadSpeedButton: TSpeedButton
    Left = 504
  end
  inherited observacionesLabel: TLabel
    Left = 72
  end
  inherited ReferencePanel: TPanel
    Width = 638
    TabOrder = 14
    inherited OpNatPanel: TPanel
      Width = 156
    end
    inherited DateCreationPanel: TPanel
      Left = 477
    end
  end
  inherited bottomPanel: TPanel
    Top = 347
    Width = 638
    TabOrder = 15
    inherited AceptarButton: TButton
      Left = 495
    end
    inherited CancelarButton: TButton
      Left = 575
    end
  end
  object RegularizacionCUCCheckBox: TCheckBox [25]
    Left = 16
    Top = 156
    Width = 137
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Regularizaci'#243'n C.U.C. :'
    TabOrder = 9
    Visible = False
    OnClick = RegularizacionCUCCheckBoxClick
    OnExit = RegularizacionCUCCheckBoxClick
  end
  object conceptoComplementaEdit: TEdit [26]
    Left = 140
    Top = 184
    Width = 481
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 80
    TabOrder = 10
    OnExit = conceptoComplementaEditExit
  end
  inherited claveAutorizaEdit: TMaskEdit
    Left = 508
    Top = 24
    TabOrder = 13
    Visible = False
  end
  inherited IncluirSoporteCheckBox: TCheckBox
    Left = 12
    Top = 308
    TabOrder = 12
  end
  inherited observacionesMemo: TMemo
    TabOrder = 11
  end
end
