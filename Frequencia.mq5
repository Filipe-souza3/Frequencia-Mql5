//+------------------------------------------------------------------+
//|                                                     fimathe2.mq5 |
//|                                                           Filipe |
//|                                                              ??? |
//+------------------------------------------------------------------+
#property copyright "Filipe"
#property link      "???"
#property version   "1.00"
#property indicator_chart_window

#include <Controls\Dialog.mqh> 
#include <Controls\Button.mqh>
#include <Controls\Label.mqh>
#include <Controls\Edit.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\ComboBox.mqh>

color cores[]={clrBlack,clrGreen,clrGray,clrYellow,clrDodgerBlue,clrBlue,clrDeepPink,clrDarkViolet,clrRed};
string coresbr[]={"Preto","Verde","Cinza","Amarelo","Azul Claro","Azul","Pink","Violeta","Vermelho"};
ENUM_LINE_STYLE estilo_linha_array[]={STYLE_SOLID,STYLE_DASH,STYLE_DOT,STYLE_DASHDOT,STYLE_DASHDOTDOT};
string estilo_linhabr[]={"Sólida", "Tracejada", "Pontilhada", "Traço-ponto", "Traço dois pontos"};


//+------------------------------------------------------------------+
//|CLASSE JANELA DE CONFIGURAÇÕES                                    |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class Janela:public CAppDialog{
   private:
      CLabel   lblvalor, lbldiferenca_pontos, lblcor_linha_50, lblcor_linha_100, 
               lblqtd_niveis_projetados, lblestilo_linha, lbllargura_linha; 
      CEdit    edtvalor, edtdif_pontos, edtqtd_niveis, edtlargura_linha;
      CCheckBox cbativa_50;
      CComboBox comboxcor_linha_50, comboxcor_linha_100, comboxestilo_linha;
      CButton btnok;
      double   valor_topo, valor_fundo;
      int      qtd_niveis, largura_linha, cor_50, cor_100, estilo_linha;
      bool     ativa_50;

   public:
      CButton  btncf, btncria, btnlimpar;
      bool     criar();
      void     limpar();
      void     moverbotao(); 
      Janela(void);
      ~Janela(void);
      virtual bool Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
      virtual bool OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam); 
  
   protected: 
      bool CreateLabel();
      bool CreateEdit();
      bool CreateCheckbox(); 
      bool CreateCombobox();
      bool CreateButton();
      void OnClickButtonok();
      bool CriarLinha(string nome, double price, int larguralinha, ENUM_LINE_STYLE estilo, color cor);
};
//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(Janela)
ON_EVENT(ON_CLICK,btnok,OnClickButtonok) 
EVENT_MAP_END(CAppDialog)

//+------------------------------------------------------------------+
//| Construtor                                                       |
//+------------------------------------------------------------------+
Janela::Janela(void){}
//+------------------------------------------------------------------+
//| Destrutor                                                        |
//+------------------------------------------------------------------+
Janela::~Janela(void){}
//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool Janela::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2){
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2)){
      return(false);   
   }
//--- controles dependentes   
   if(!CreateLabel()){
      return(false);
   }
   
   if(!CreateEdit()){
      return(false);
   }
   
   if(!CreateCheckbox()){
     return(false);
   } 
   
   if(!CreateCombobox()){
     return(false);
   }
   
   if(!CreateButton()){
      return(false);
   } 
   
   return(true);
}
//+------------------------------------------------------------------+
//| Create Label                                                     |
//+------------------------------------------------------------------+
bool Janela::CreateLabel(void){
   int x1,y1,x2,y2;
   x1 = 11;
   y1 = 11;
   x2 = 100+x1;
   y2 = 20+y1;
   
   color cor=clrBlack;
   int fontsize=10;
   
   
   //---Valor
   if(!lblvalor.Create(0,"labelvalor",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!lblvalor.Color(cor)){
      return(false);
   }
   if(!lblvalor.Text("Valor topo")){
      return(false);
   }
   if(!lblvalor.FontSize(fontsize)){
      return(false);
   }
   if(!Add(lblvalor)){
      return(false);
   }
   
   //---Valor em pontos
   y1 +=41;
   if(!lbldiferenca_pontos.Create(0,"labelvalor_pontos",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!lbldiferenca_pontos.Color(cor)){
      return(false);
   }
   if(!lbldiferenca_pontos.Text("Valor fundo")){
      return(false);
   }
   if(!lbldiferenca_pontos.FontSize(fontsize)){
      return(false);
   }
   if(!Add(lbldiferenca_pontos)){
      return(false);
   }
   
   //--- cor da linha 50
   y1 +=71;
   if(!lblcor_linha_50.Create(0,"lblcor_linha_50",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!lblcor_linha_50.Color(cor)){
      return(false);
   }
   if(!lblcor_linha_50.Text("Cor da linha 50%")){
      return(false);
   }
   if(!lblcor_linha_50.FontSize(fontsize)){
      return(false);
   }
   if(!Add(lblcor_linha_50)){
      return(false);
   }
   
   //--- cor da linha 100
   x1+=120;
   if(!lblcor_linha_100.Create(0,"lblcor_linha_100",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!lblcor_linha_100.Color(cor)){
      return(false);
   }
   if(!lblcor_linha_100.Text("Cor da linha 100%")){
      return(false);
   }
   if(!lblcor_linha_100.FontSize(fontsize)){
      return(false);
   }
   if(!Add(lblcor_linha_100)){
      return(false);
   }
   
   //--- quantidade de niveis projetados
   x1+=0;
   y1=11;
   if(!lblqtd_niveis_projetados.Create(0,"lblqtd_niveis_projetados",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!lblqtd_niveis_projetados.Color(cor)){
      return(false);
   }
   if(!lblqtd_niveis_projetados.Text("Qtd de níveis projetados")){
      return(false);
   }
   if(!lblqtd_niveis_projetados.FontSize(fontsize)){
      return(false);
   }
   if(!Add(lblqtd_niveis_projetados)){
      return(false);
   }
  
    //--- estilo da linha
   x1=130;
   y1=52;
   if(!lblestilo_linha.Create(0,"lblestilo_linha",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!lblestilo_linha.Color(cor)){
      return(false);
   }
   if(!lblestilo_linha.Text("Estilo das linhas")){
      return(false);
   }
   if(!lblestilo_linha.FontSize(fontsize)){
      return(false);
   }
   if(!Add(lblestilo_linha)){
      return(false);
   }
   
   //--- estilo da linha
   x1=130;
   y1=100;
   x2=100+x1;
   y2 = 20+y1;
   if(!lbllargura_linha.Create(0,"lbllargura_linha",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!lbllargura_linha.Color(cor)){
      return(false);
   }
   if(!lbllargura_linha.Text("Largura da linha")){
      return(false);
   }
   if(!lbllargura_linha.FontSize(fontsize)){
      return(false);
   }
   if(!Add(lbllargura_linha)){
      return(false);
   }
   
   
   return(true);
}

//+------------------------------------------------------------------+
//|Create Edit                                                       |
//+------------------------------------------------------------------+
bool Janela::CreateEdit(void){
   int x1,y1,x2,y2;
   
   //---caixa de quantidade de niveis
   x1=130; 
   x2 = 30+x1; 
   y1=30;
   y2=20+y1;
   if(!edtqtd_niveis.Create(0,"edtqtd_niveis",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!Add(edtqtd_niveis)){
      return(false);
   }
   edtqtd_niveis.Text("4");
   qtd_niveis=4;
   
   //---caixa largura da linha
   x1=230;
   y1=100;
   x2=30+x1;
   y2 = 20+y1;
   if(!edtlargura_linha.Create(0,"edtlargura_linha",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!Add(edtlargura_linha)){
      return(false);
   }
   edtlargura_linha.Text("2");
   largura_linha =2;
   
   x1 = 11;
   y1 = 30;
   x2 = 80+x1;
   y2 = 20+y1;
   
   //--- caixa valor
   if(!edtvalor.Create(0,"edtvalor",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!Add(edtvalor)){
      return(false);
   }
   
   
   //---caixa diferença em pontos
   y1 = 72;
   y2 = 20+y1;
   if(!edtdif_pontos.Create(0,"edtdif_pontos",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!Add(edtdif_pontos)){
      return(false);
   }

   return(true);
}
//+------------------------------------------------------------------+
//| Create checkbox                                                  |
//+------------------------------------------------------------------+
bool Janela::CreateCheckbox(void){
   int x1,y1,x2,y2;
   x1=11;
   y1=100;
   x2=100+x1;
   y2 = 20+y1;

   if(!cbativa_50.Create(0,"cbativa_50",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!cbativa_50.Text("Ativar 50%")){
      return(false);
   }
   if(!Add(cbativa_50)){
      return(false);
   }
   
   return(true);
}
//+------------------------------------------------------------------+
//| Create combobox                                                  |
//+------------------------------------------------------------------+
bool Janela::CreateCombobox(void){
   int x1,y1,x2,y2;
   x1=11;
   y1=144;
   x2=80+x1;
   y2 = 20+y1;

   
   //---cor da linha 50%
   if(!comboxcor_linha_50.Create(0,"comboxcor_linha_50",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!Add(comboxcor_linha_50)){
      return(false);
   }
   
    for(int i=0;i<ArraySize(cores);i++){
      if(!comboxcor_linha_50.AddItem(coresbr[i])){
         return(false);
      }
    }
    comboxcor_linha_50.SelectByText(coresbr[2]);
    cor_50 = 2;
    
   //---cor da linha 100%
   x1+=119;
   x2=80+x1;
   if(!comboxcor_linha_100.Create(0,"comboxcor_linha_100",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!Add(comboxcor_linha_100)){
      return(false);
   }

    for(int i=0;i<ArraySize(cores);i++){
      if(!comboxcor_linha_100.ItemAdd(coresbr[i])){
         return(false);
      }
    } 
   comboxcor_linha_100.SelectByText(coresbr[4]);
   cor_100=4;
   
   //---estilo das linhas
   x1=130; 
   x2 = 112+x1; 
   y1=72;
   y2=20+y1;
   if(!comboxestilo_linha.Create(0,"comboxestilo_linha",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!Add(comboxestilo_linha)){
      return(false);
   }

    for(int i=0;i<=4;i++){
      if(!comboxestilo_linha.ItemAdd(estilo_linhabr[i])){
         return(false);
      }
    } 
    comboxestilo_linha.SelectByText(estilo_linhabr[1]);
    estilo_linha = 1;
     
   return(true);   
}
//+------------------------------------------------------------------+
//| Create Button                                                    |
//+------------------------------------------------------------------+
bool Janela::CreateButton(void){
   int x1,y1,x2,y2;
   x1=11;
   y1=180;
   x2=100+x1;
   y2=20+y1;
   
   //---botao ok
   if(!btnok.Create(0,"btnok",0,x1,y1,x2,y2)){
      return(false); 
   };
   if(!Add(btnok)){
      return(false);
   };
   if(!btnok.Text("OK")){
      return(false);
   }
   
   //---botao conf
   x1 = 8;
   y1 = ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0)-30;
   x2 = 34+x1;
   y2 = 20+y1;
   if(!btncf.Create(0,"btncf",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!btncf.Text("Conf")){
      return(false);
   }
   
   
   //---botao criar
   x1= 50;
   x2= 34+x1;
   if(!btncria.Create(0,"btncria",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!btncria.Text("Criar")){
      return(false);
   }
   
   //---botao limpar
   x1= 92;
   x2= 45+x1;
   if(!btnlimpar.Create(0,"btnlimpa",0,x1,y1,x2,y2)){
      return(false);
   }
   if(!btnlimpar.Text("Limpar")){
      return(false);
   }
   
   return(true);
}
//+------------------------------------------------------------------+
//| OnClick button ok                                                |
//+------------------------------------------------------------------+
void Janela::OnClickButtonok(void){
   if(btnok.Pressed(false)){
      
      valor_topo     = (double)ObjectGetString(0,"edtvalor",OBJPROP_TEXT,0);
      valor_fundo    = (double)ObjectGetString(0,"edtdif_pontos",OBJPROP_TEXT,0);
      
      qtd_niveis     = (int)ObjectGetString(0,"edtqtd_niveis",OBJPROP_TEXT,0);
      if(qtd_niveis==0){qtd_niveis=1;} 
      largura_linha  = (int)ObjectGetString(0,"edtlargura_linha",OBJPROP_TEXT,0); 
      if(largura_linha==0){largura_linha=1;} 
      
      ativa_50       = cbativa_50.Checked();
      
      string s_cor_50         = comboxcor_linha_50.Select();
      string s_cor_100        = comboxcor_linha_100.Select();
      string s_estilo_linha   = comboxestilo_linha.Select();
      
      for(int i=0; i<ArraySize(coresbr);i++){
         if(s_cor_100 == coresbr[i]){
            cor_100 = i;
         }
         if(s_cor_50 == coresbr[i]){
            cor_50 = i;
         }
      }
      
      for(int i=0; i<ArraySize(estilo_linhabr);i++){
         if(s_estilo_linha == estilo_linhabr[i]){
            estilo_linha = i;
         }
      }
            
      if(qtd_niveis==0){
          PlaySound("alert2.wav");
          MessageBox("Campo 'Qtd níveis projetados' possui valor inválido","Atenção",0);
      }
        if(largura_linha==0){
          PlaySound("alert2.wav");
          MessageBox("Campo 'Largura da linha' possui valor inválido","Atenção",0);
      }
      jnl.Hide();    
   }
}
//+------------------------------------------------------------------+
//| Criar linhas                                                     |
//+------------------------------------------------------------------+
bool Janela::criar(void){
   int hline = ObjectsTotal(0,0,OBJ_HLINE);
   double topo_price,fundo_price,troca_price, troca_price_50;
   string topline, botline, topline_50, botline_50;
   color cor_do_100, cor_do_50;
   
   if(valor_topo==0 || valor_fundo==0){
   
      if(hline>2 || hline<2){
         return(false);
      }
      
      string topo = ObjectName(0,1,0,OBJ_HLINE);
      string fundo = ObjectName(0,0,0,OBJ_HLINE);
      
      topo_price = ObjectGetDouble(0,topo,OBJPROP_PRICE); 
      fundo_price = ObjectGetDouble(0,fundo,OBJPROP_PRICE);
      
      ObjectDelete(0,topo);
      ObjectDelete(0,fundo);
   }else{
      topo_price = valor_topo;
      fundo_price = valor_fundo;
   }   
   
   if(fundo_price > topo_price){
      troca_price = topo_price;
      topo_price = fundo_price;
      fundo_price = troca_price;
   }
   
   troca_price = topo_price - fundo_price;
   cor_do_100 = cores[cor_100];
   cor_do_50 = cores[cor_50];
   
   for(int i=0; i<=qtd_niveis; i++){
      StringConcatenate(topline,"linetop",(string)i);
      StringConcatenate(botline,"linebottom",(string)i);
      
      if(!CriarLinha(topline,topo_price,largura_linha,estilo_linha_array[estilo_linha],cor_do_100)){return (false);}
      if(!CriarLinha(botline,fundo_price,largura_linha,estilo_linha_array[estilo_linha],cor_do_100)){return (false);}
    
      if(ativa_50){
          StringConcatenate(topline_50,"linetop_50",(string)i);
          StringConcatenate(botline_50,"linebottom_50",(string)i);
           
           
         if(i == 0){
            troca_price_50 = troca_price/2;   
            troca_price_50 = topo_price - troca_price_50;
            if(!CriarLinha(topline_50,troca_price_50,largura_linha,estilo_linha_array[estilo_linha],cor_do_50)){return(false);}
         }else{
            troca_price_50 = topo_price - (troca_price/2);
            if(!CriarLinha(topline_50,troca_price_50,largura_linha,estilo_linha_array[estilo_linha],cor_do_50)){return(false);}
         
            troca_price_50 = fundo_price + (troca_price/2);
            if(!CriarLinha(botline_50,troca_price_50,largura_linha,estilo_linha_array[estilo_linha],cor_do_50)){return(false);}
         }
      
      }
      
      topo_price = topo_price+troca_price;
      fundo_price = fundo_price-troca_price;
  }
     Print(ativa_50);
   Print(troca_price_50);
//Print(topo_price,"",fundo_price);
   return(true);
}

//+------------------------------------------------------------------+
//| Criar linha                                                      |
//+------------------------------------------------------------------+
bool Janela::CriarLinha(string nome, double price, int larguralinha, ENUM_LINE_STYLE estilo, color cor){
   
   if(!ObjectCreate(0,nome,OBJ_HLINE,0,0,price)){return(false);}
      ObjectSetInteger(0,nome,OBJPROP_BACK,true);
      ObjectSetInteger(0,nome,OBJPROP_WIDTH,larguralinha);
      ObjectSetInteger(0,nome,OBJPROP_STYLE,estilo);
      ObjectSetInteger(0,nome,OBJPROP_SELECTABLE,true);
      ObjectSetInteger(0,nome,OBJPROP_SELECTED,false);
      ObjectSetInteger(0,nome,OBJPROP_HIDDEN,false);
      ObjectSetInteger(0,nome,OBJPROP_COLOR,cor);

   return(true);
}
//+------------------------------------------------------------------+
//| Mover eixo y para botoes conf e criar e limpar                   |
//+------------------------------------------------------------------+
Janela::moverbotao(void){

   int width=ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);
   
   ObjectSetInteger(0,"btncf",OBJPROP_YDISTANCE,width-30);
   ObjectSetInteger(0,"btncria",OBJPROP_YDISTANCE,width-30);
   ObjectSetInteger(0,"btnlimpa",OBJPROP_YDISTANCE,width-30);
}


//+------------------------------------------------------------------+
//| limpar linhas                                                    |
//+------------------------------------------------------------------+
void Janela::limpar(void){
   //int hline = ObjectsTotal(0,0,OBJ_HLINE);
   int hline = ObjectsDeleteAll(0,0,OBJ_HLINE);
   if(hline ==0 ){
      PlaySound("alert2.wav");
      MessageBox("A quantidade de objetos 'hline' é 0.","Atenção",0);
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Variaveis globais                                                |
//+------------------------------------------------------------------+
Janela jnl;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
 
//--- indicator buffers mapping
   if(!jnl.Create(0,"Configurações",0,40,40,350,280)){
      return(INIT_FAILED);
   }else{ 
      jnl.Run();
     // jnl.Hide();
      }

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+ 
//| Expert deinitialization function                                 | 
//+------------------------------------------------------------------+ 
void OnDeinit(const int reason) 
  { 
//--- destroy dialog 
   jnl.Destroy(reason); 
  } 
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
  
   
 
  
   
   
   
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   // Print(sparam);

   if(id==CHARTEVENT_OBJECT_CLICK){
      string param = StringSubstr(sparam,5,6);
      if(param == "Close" || param == "MinMax"){
         jnl.Hide();
      }
   }
  
   jnl.ChartEvent(id,lparam,dparam,sparam);
   
   if(jnl.btncf.Pressed()){
      jnl.Show();
      jnl.btncf.Pressed(false);
   }


    if(jnl.btncria.Pressed()){
     
      if(jnl.criar()){
         Print("Criado com sucesso."); 
      }else{
         MessageBox("Erro ao criar.","Atenção",0);
         PlaySound("alert2.wav");
         
      }

      jnl.btncria.Pressed(false);      
   }
   
   if(jnl.btnlimpar.Pressed()){
      jnl.limpar();
      jnl.btnlimpar.Pressed(false);
   }
   
   if(id==CHARTEVENT_CHART_CHANGE){
      jnl.moverbotao();
   }
  }
//+------------------------------------------------------------------+
