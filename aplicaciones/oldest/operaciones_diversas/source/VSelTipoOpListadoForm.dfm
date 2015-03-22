object SelTipoOpListadoForm: TSelTipoOpListadoForm
  Left = 252
  Top = 131
  BorderStyle = bsDialog
  Caption = 'Par'#225'metros del listado por Tipos de Operaci'#243'n...'
  ClientHeight = 499
  ClientWidth = 430
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
  object LabelCabecera: TLabel
    Left = 12
    Top = 20
    Width = 181
    Height = 13
    Caption = 'Par'#225'metros del listado para la fecha/s:'
  end
  object separarTerminalesCheckBox: TCheckBox
    Left = 12
    Top = 136
    Width = 137
    Height = 17
    Caption = 'Separar por terminales'
    TabOrder = 3
  end
  object indicarSoporteEnvioCheckBox: TCheckBox
    Left = 12
    Top = 52
    Width = 205
    Height = 17
    Caption = 'Indicar el soporte en el que se envi'#243
    Checked = True
    State = cbChecked
    TabOrder = 0
    OnClick = indicarSoporteEnvioCheckBoxClick
  end
  object incluirSoloTiposCheckBox: TCheckBox
    Left = 12
    Top = 220
    Width = 185
    Height = 17
    Caption = 'S'#243'lo incluir los tipos indicados:'
    TabOrder = 6
    OnClick = incluirSoloTiposCheckBoxClick
  end
  object tiposAIncluirCheckListBox: TCheckListBox
    Left = 28
    Top = 248
    Width = 393
    Height = 129
    Enabled = False
    ItemHeight = 13
    Items.Strings = (
      '01 - Efectos (Cobros)'
      '02 - Cheques (Cobros)'
      
        '03 - Reg. operaciones de Sistemas de Intercambio. Documental. (C' +
        'obros/Pagos)'
      
        '04 - Reg. operaciones de Sistemas de Intercambio. No documental.' +
        ' (Cobros/Pagos)'
      '05 - Actas de protesto (Cobors)'
      '06 - Comisiones y gastos de cr'#233'ditos/remesas (Cobros)'
      '07 - Pagos en notar'#237'a (Pagos)'
      '08 - Comisiones de efectivo (Cobros)'
      '09 - Compraventa de moneda extranjera (Cobros/Pagos)'
      '10 - Reembolsos (Cobros/Pagos)'
      '11 - Regularizaci'#243'n desfases tesoreros (Cobros/Pagos)'
      '12 - Comisiones (Cobros)'
      
        '13 - Recup. de comisiones/intereses de los Subsistemas de Interc' +
        'ambio (Cobros)'
      '14 - Otras operaciones (Cobros/Pagos)'
      'DEV - Devoluciones')
    TabOrder = 7
  end
  object emitirResumenCheckBox: TCheckBox
    Left = 12
    Top = 420
    Width = 273
    Height = 17
    Caption = 'Emitir un cuadro/resumen con todos los tipos al final'
    Enabled = False
    TabOrder = 9
  end
  object saltoPaginaCheckBox: TCheckBox
    Left = 12
    Top = 392
    Width = 269
    Height = 17
    Caption = 'Imprimir cada tipo de operaci'#243'n en una p'#225'gina'
    TabOrder = 8
  end
  object AceptarBtn: TButton
    Left = 260
    Top = 464
    Width = 75
    Height = 25
    Caption = 'Aceptar'
    TabOrder = 10
  end
  object CancelarBtn: TButton
    Left = 344
    Top = 464
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 11
  end
  object separarDiasCheckBox: TCheckBox
    Left = 12
    Top = 108
    Width = 113
    Height = 17
    Caption = 'Separar por d'#237'as'
    TabOrder = 2
  end
  object separarTiposCheckBox: TCheckBox
    Left = 12
    Top = 164
    Width = 189
    Height = 17
    Caption = 'Separar por tipos de operaciones'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = separarTiposCheckBoxClick
  end
  object separarPorSoporteCheckBox: TCheckBox
    Left = 28
    Top = 80
    Width = 121
    Height = 17
    Caption = 'Separar por soportes'
    TabOrder = 1
  end
  object anadirDatosEspecificosOpCheckBox: TCheckBox
    Left = 32
    Top = 192
    Width = 249
    Height = 17
    Caption = 'A'#241'adir datos espec'#237'ficos de cada operaci'#243'n'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
end
