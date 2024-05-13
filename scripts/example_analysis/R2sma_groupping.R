rm(list = ls())
pacman::p_load(dplyr,purrr,ggplot2,toolPhD,ggpmisc,ggh4x)
R_raw <- readRDS("output/sma_Raw.RDS") 
source("src/fun/Cor_fun.R")
R_raws <- R_raw%>%
  ungroup() %>% 
  tidyr::separate("combi",c("F1","F2"),sep="\n",)%>% 
  tidyr::separate("F1",c("L1","Y1"),sep="-")%>% 
  tidyr::separate("F2",c("L2","Y2"),sep="-") %>% 
  mutate(sl=case_when(L1==L2~"SL",
                      T~"DL"),
         sy=case_when(Y1==Y2~"SY",
                      T~"DY"),
         ck=paste(sl,sy)) %>% 
  filter( R_type=="R2_sma",
          data=="y3_g194")
sumtb <- function(tb){
  with(tb,
       data.frame(L=c(L1,L2),
                  Y=c(Y1,Y2)))%>%
    table() %>% addmargins()
}
# -------------------------------------------------------------------------
fillpalette <- viridis::viridis(3)
names(fillpalette) <- c("HN_WF","HN_NF","LN_NF")

nice_break <- function(range.vec,nbk,digit,include=T){
  axis_breaks <- pretty(range.vec, nbk)
  
  axis_breaks <- round(axis_breaks,digit)
  if(include==T){
    axis_breaks <-  axis_breaks[axis_breaks >= min(range.vec) & axis_breaks <= max(range.vec)]
  }
  return(axis_breaks)
}

lsddf<- function(formu,dat){
  datinfo <- dat %>% select(f2,factor,type,f1) %>% distinct()
  
  resl <- aov(as.formula(formu),data=dat) %>%
    agricolae::LSD.test(.,"f1", group=TRUE)
  if (is.null(resl)|length(unique(resl$groups$groups))==1){
    datinfo %>% mutate(
      R2=0,
      groups=''
    )
  }else{
    resl$means %>% .["Min"] %>%
      merge(.,resl$groups%>% .["groups"],by=0, all=TRUE) %>% 
      rename(R2=Min,f1=Row.names) %>% 
      left_join(datinfo,"f1")
  }
}

plot_raw2<- function(tr,rtype,dtype,target=NULL){
  # stacked version vertical for plot_raw()
  condi_ls <-list(rlang::quos(type%in%c("Treatment","Location","Year")),
                  rlang::quos(!type%in%c("Treatment","Location","Year"))
  )
  
  if(is.null(target)){
    target <- "R2"
    ylabtext <- 'R["sma"]^"2"'
    ylimits <- c(0,1.18)
    ybreaks <-  seq(0,1,.2)
    texty <- 1.13
  }else if (target=="sma_slope"){
    # target <- "sma_slope"
    ylabtext <- 'Slope["sma"]'
    
  }
  sub_df <- R_raw %>%rename(tar=target) %>% 
    dplyr::filter(!is.na(tar),trait==tr,data==dtype,R_type==rtype) %>% 
    group_by(factor) %>% 
    mutate(n=n()) %>% ungroup() %>%
    group_by(f1) %>% 
    mutate(Out=out_fin(tar))%>% ungroup()
  
  res <- list(sub_df %>%filter(n>2,
                               type%in%c("Treatment","Location","Year")) %>% 
                group_by(type) %>% 
                group_split() %>% 
                map_dfr(.,~{lsddf("tar~f1",.x)})%>% rename(tar=R2)
              ,
              sub_df %>%filter(n>2,!type%in%c("Treatment","Location","Year")) %>% 
                group_by(f2,type) %>% 
                mutate(n=length(unique(f1))) %>% 
                filter(n>1) %>% 
                group_split() %>% 
                map_dfr(.,~{lsddf("tar~f1",.x)})%>% rename(tar=R2)
              
  ) 
  
  plotdf_all <- sub_df %>%
    #### Groups with fewer than two data points have been dropped.
    filter(n>1) %>% 
    mutate(f2=case_when(is.na(f2)~"",T~f2)) %>%
    group_by(type,f2,f1) %>% 
    mutate(r1=paste0(
      "M:",max(tar) %>% round(.,2),"\n",
      "A:",mean(tar)%>% round(.,2),"\n",
      "m:",min(tar) %>% round(.,2))
    ) %>% ungroup() 
  
  if(target=="sma_slope"){
    
    ylimits <- plotdf$tar %>% range()
    ybreaks <- nice_break(ylimits,include = T,digit = 2,nbk = 4)
    texty <- ylimits[2]*1.1
    if(ylimits[1]>0){
      ylimits <- c(-0.7,ylimits[2]*1.2)
    }else{
      ylimits <- c(ylimits[1]*1.05,ylimits[2]*1.2)
    }
    
    
  }
  
  pl <- map(1:2,~{
    plotdf<- plotdf_all %>% 
      filter(!!!condi_ls[[.x]])
    ssdf <- sub_df%>% 
      filter(!!!condi_ls[[.x]])
    p <- plotdf%>% 
      ggplot(aes(f1,tar,group=factor,fill=f1))
    if(target=="sma_slope"){
      p <- p+geom_hline(yintercept = 1,linetype=2,color="darkgray")
    }
    
    p <- p+
      scale_fill_manual(values = fillpalette)+
      geom_violin(alpha=0.5,position = position_dodge(width = .75),size=1,color=NA) +
      geom_boxplot(outlier.size = -1, color="black",
                   position = position_dodge(width = .75),
                   lwd=.5,width=.1,alpha = 0.1,show.legend = F)+
      ggbeeswarm::geom_quasirandom(aes(shape=Rsign,size=npoint), dodge.width = .75, 
                                   color="black",show.legend = F)+
      scale_size(range = c(.5, 2))+
      scale_shape_manual(values=shp2)+
      theme_classic()+
      theme(
        panel.spacing = unit(0.1, "lines"),
        axis.text.x=element_text(angle=90,vjust=.5),
        strip.background = element_blank(),
        panel.grid.major.x = element_blank(),
        strip.text = element_text(color="black",size=13,face = 'bold'),
        axis.line = element_line(colour = "black",size=1),
        axis.ticks = element_line(size=1,color="black"),
        axis.title =  element_text(color="black",size=13),
        axis.text = element_text(color="black",size=12,face = 'bold'),
        axis.ticks.length=unit(0.2,"cm"),
        legend.position = "bottom")+
      guides(fill = guide_legend(title="management",override.aes = list(alpha = 1,color="black")))+
      ylab(parse(text=ylabtext))+
      xlab('growing condition (YxLxM) factor')+
      ggtitle(
        parse(text=paste(tr,'~R[sma]^"2":~',round(min(ssdf$tar),2),
                         '*"~"*',round(max(ssdf$tar),2))))+
      scale_color_manual(values=col_pal)+
      facet_nested(~forcats::fct_relevel(type,"Year","Location","Treatment",
                                         "Treatment-Location","Treatment-Year")+f2,
                   # nrow = 1,
                   nest_line = element_line(colour = "black"),space = 'free',
                   scale="free_x") +
      geom_text(  data=plotdf %>%
                    select(f1,f2,type,r1,factor) %>% distinct() %>% 
                    mutate(tar=texty),
                  mapping=aes(f1,tar,label=r1),
                  color="darkblue",size=3.4
      )+
      geom_text(data=res[[.x]] %>%
                  mutate(f2=case_when(is.na(f2)~"",T~f2),
                         tar=0),
                mapping=aes(f1,tar,label=groups),color="darkred",
                show.legend = F)+
      scale_y_continuous(limits=ylimits,breaks = ybreaks)
    if(.x==1){
      p <- p+theme(axis.title.x=element_blank(),legend.position = "none")
    }
    return(p)
  })
  cowplot::plot_grid(plotlist = pl,nrow = 2,rel_heights = c(.8,1))
  
  
}
dfun <- function(x){
  x %>%
    .[,!sapply(x, function(x)all(is.na(x)))] %>% 
    as.data.frame() %>% 
    arrange({{typ}}) %>% 
    `rownames<-`(.[[typ]]) %>% 
    select(-all_of(c("type","R_type","f2",typ))) %>%  
    rbind(rep(.8,ncol(.)) , rep(0,ncol(.)) , .)
}
# plot -------------------------------------------------------------------------
# tr_vec<- c('Seedyield','Crude_protein','Straw','HI','Biomass','TKW','Kernel','KperSpike',"Spike_number")
col_pal<- viridis::viridis(4)
names(col_pal) <- c("HN_NF","HN_WF","LN_NF","LN_WF")
shp2 <- c(1,2)
names(shp2) <- c("+","-")
# dtype.vec <- R_raw$data %>% unique()
# R <- "R2_sma"
png(filename="figure/R2sma_groups.png",
    type="cairo",
    units="cm",
    height = 18,width = 30,
    pointsize=3,
    res=650,# dpi,
    family="Arial")

walk(c('Seedyield'),~{
  plot_raw2(.x,R,R_raw$data %>% unique()) %>%print() 
})
dev.off()

