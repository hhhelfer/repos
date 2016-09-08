forecasts.dlab=function(y,X,h=1,npred=8,alpha.sh=0,alpha.ew=0.95){
  ## ==== funcao hmfv ==== ##
  aux=embed(y,h+1)
  y=aux[,1]
  lagy=aux[,ncol(aux)]
  
  ldy=diff(log(y),1)
  ldlagy=diff(log(lagy),1)
  
  T=length(y)
  TT=length(ldy)
  
  Xnv=tail(X,T)
  Xlv=tail(X,TT)
  
  Xall.nv=cbind(lagy,Xnv)
  Xall.lv=cbind(ldlagy,Xlv)
  
  ## === Autorregressivo === ##
  # = Nivel = #
  {
    save.ar.niv=rep(NA,nprev)
    for(i in 1:nprev){
      model=lm(y[1:(T-nprev-1+i)]~lagy[1:(T-nprev-1+i)])
      prev=c(1,lagy[(T-nprev+i)])%*%coef(model)
      save.ar.niv[i]=prev
    }
  }
  # = log variacao = #
  {
    save.ar.lv=rep(NA,nprev)
    for(i in 1:nprev){
      model=lm(ldy[1:(TT-nprev-1+i)]~ldlagy[1:(TT-nprev-1+i)])
      prev=c(1,ldlagy[(TT-nprev+i)])%*%coef(model)
      save.ar.lv[i]=prev
    }
    save.ar.lv=exp(save.ar.lv)*y[(length(y)-nprev):(length(y)-1)]
  }
  
  
  ## === AR X === ##
  # = Nivel = #
  {
    save.arx.niv=rep(NA,nprev)
    for(i in 1:nprev){
      model=lm(y[1:(T-nprev-1+i)]~Xall.nv[1:(T-nprev-1+i),])
      prev=c(1,Xall.nv[(T-nprev+i),])%*%coef(model)
      save.arx.niv[i]=prev
    }
  }
  # = log variacao = #
  {
    save.arx.lv=rep(NA,nprev)
    for(i in 1:nprev){
      model=lm(ldy[1:(TT-nprev-1+i)]~Xall.lv[1:(TT-nprev-1+i),])
      prev=c(1,Xall.lv[(TT-nprev+i),])%*%coef(model)
      save.arx.lv[i]=prev
    }
    save.arx.lv=exp(save.arx.lv)*y[(length(y)-nprev):(length(y)-1)]
  }
  
  
  ## == shrinkage == ##
  # = Nivel = #
  {
    save.sh.niv=rep(NA,nprev)
    
    for(i in 1:nprev){
      model=biclasso(Xall.nv[1:(T-nprev-1+i),],y[1:(T-nprev-1+i)],alpha=alpha.sh)
      prev=c(1,Xall.nv[(T-nprev+i),])%*%model$coef
      save.sh.niv[i]=prev
    }
  }
  
  # = log variacao = #
  {
    save.sh.lv=rep(NA,nprev)
    
    for(i in 1:nprev){
      model=biclasso(Xall.lv[1:(TT-nprev-1+i),],ldy[1:(TT-nprev-1+i)],alpha=alpha.sh)
      prev=c(1,Xall.lv[(TT-nprev+i),])%*%model$coef
      save.sh.lv[i]=prev
    }
    save.sh.lv=exp(save.sh.lv)*y[(length(y)-nprev):(length(y)-1)]
  }
  
  
  ## == EWMA == ##
  # = Nivel = #
  {
    save.ew.niv=rep(NA,nprev)
    
    for(i in 1:nprev){
      prev=ses(y[1:(T-nprev-1+i)],alpha=alpha.ew,h=h)$mean[h]
      save.ew.niv[i]=prev
    }
  }
  
  # = log variacao = #
  {
    save.ew.lv=rep(NA,nprev)
    
    for(i in 1:nprev){
      model=biclasso(Xall.lv[1:(TT-nprev-1+i),],ldy[1:(TT-nprev-1+i)],alpha=alpha.sh)
      prev=ses(ldy[1:(TT-nprev-1+i)],alpha=alpha.ew,h=h)$mean[h]
      save.ew.lv[i]=prev
    }
    save.ew.lv=exp(save.ew.lv)*y[(length(y)-nprev):(length(y)-1)]
  }
  
  
  ## == Random Forest == ##
  # = Nivel = #
  {
    save.rf.niv=rep(NA,nprev)
    
    for(i in 1:nprev){
      model=randomForest(Xall.nv[1:(T-nprev-1+i),],y[1:(T-nprev-1+i)])
      prev=predict(model,Xall.nv[(T-nprev+i),])
      save.rf.niv[i]=prev
    }
  }
  
  # = log variacao = #
  {
    save.rf.lv=rep(NA,nprev)
    
    for(i in 1:nprev){
      model=randomForest(Xall.lv[1:(TT-nprev-1+i),],ldy[1:(TT-nprev-1+i)])
      prev=predict(model,Xall.lv[(TT-nprev+i),])
      save.rf.lv[i]=prev
    }
    save.rf.lv=exp(save.rf.lv)*y[(length(y)-nprev):(length(y)-1)]
  }
  
  nivel=cbind(save.ar.niv,save.arx.niv,save.ew.niv,save.sh.niv,save.rf.niv)
  nivel=cbind(nivel,rowMeans(nivel))
  logvar=cbind(save.ar.lv,save.arx.lv,save.ew.lv,save.sh.lv,save.rf.lv)
  logvar=cbind(logvar,rowMeans(logvar))
  colnames(nivel)=colnames(logvar)=c("AR","ARX","EWMA","LASSO","Random Forest","AVG")
  real=tail(y,nprev)
  
  return(list("logvar"=logvar,"nivel"=nivel,"real"=real))
}