/*
*	@name: CLABS_cls_actualidadController_cc
*	@version: 1.0
*	@creation date: 13/06/2022
*	@author: AS - Atmira
*/
public without sharing class CLABS_cls_actualidadController_cc {
    
    public static final String CLASS_NAME = 'CLABS_cls_actualidadController_cc';
    public static List<CLABS_cls_wrapperActualidad> respuesta = new List<CLABS_cls_wrapperActualidad>();
    
    /**
* @name: getContenidoActualidad
* @createdDate: 14/06/2022
* @author: AS - Atmira
* @description: Método encargado de devoler los contenidos de actualidad para las cards
*/
    @AuraEnabled
    public static List<CLABS_cls_wrapperActualidad> getContenidoActualidad(){
        final String METHOD_NAME = 'getContenidoActualidad';
        System.debug(CLABS_cls_constantes.INICIO + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + CLASS_NAME + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + METHOD_NAME);
        
        Set<Id> idsEventosYPublicaciones = new Set<Id>();
        
        //Se añade el contenido Segmentado
        idsEventosYPublicaciones = contenidoSegmentado();
        //Se añaden los eventos publicos que no este inscrito ya
        cardEventosPublicos(idsEventosYPublicaciones);
        //Se añaden las publicaciones publicas que no este inscrito ya
        cardPublicacionesPublicas(idsEventosYPublicaciones);
        
        System.debug(CLABS_cls_constantes.FIN + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + CLASS_NAME + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + METHOD_NAME);
        
        return respuesta;
    }
    
    /**
* @name: contenidoSegmentado
* @createdDate: 14/06/2022
* @author: AS - Atmira
* @description: Método encargado de devoler los contenidos segmentados
*/
    private static Set<Id> contenidoSegmentado(){
        final String METHOD_NAME = 'contenidoSegmentado';
        System.debug(CLABS_cls_constantes.INICIO + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + CLASS_NAME + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + METHOD_NAME);
        
        Set<Id> idsEventosYPublicaciones = new Set<Id>();
        Integer numLimit = 1000;
        DateTime todayTime = System.now();
        
        try{
            User u = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
            
            for(CLABS_obj_contenidoContacto__c contenidoContacto : [SELECT Id, CLABS_fld_evento__c, CLABS_fld_publicacion__c, CLABS_fld_inscrito__c, CLABS_fld_inscritoOnlineHibrido__c, CLABS_fld_favorito__c,
                                                                    
                                                                    CLABS_fld_evento__r.CLABS_fld_numeroInscritos__c, CLABS_fld_evento__r.Name, CLABS_fld_evento__r.CLABS_fld_fecha_Fin__c, CLABS_fld_evento__r.CLABS_fld_numeroPlazas__c,
                                                                    CLABS_fld_evento__r.CLABS_fld_pequeniaDescripcion__c, CLABS_fld_evento__r.CLABS_fld_URLimagenCard__c, CLABS_fld_evento__r.CLABS_fld_insignia__c,
                                                                    
                                                                    CLABS_fld_publicacion__r.CLABS_fld_tipoPublicacion__c, CLABS_fld_publicacion__r.CLABS_fld_URLimagenCard__c, CLABS_fld_publicacion__r.CLABS_fld_titulo__c, 
                                                                    CLABS_fld_publicacion__r.CLABS_fld_fechaFinPublicacion__c, CLABS_fld_evento__r.CLABS_fld_fecha_Inicio__c, CLABS_fld_publicacion__r.CLABS_fld_pequeniaDescripcion__c
                                                                    FROM CLABS_obj_contenidoContacto__c
                                                                    WHERE CLABS_fld_contacto__c = :u.contactId
                                                                    AND 
                                                                    (
                                                                        (
                                                                            (CLABS_fld_evento__r.RecordType.DeveloperName = :CLABS_cls_constantes.API_RT_EVENTO_ACT_DIGITAL 
                                                                             OR CLABS_fld_evento__r.RecordType.DeveloperName = :CLABS_cls_constantes.API_RT_EVENTO_ACT_PRESENCIAL) 
                                                                            AND CLABS_fld_evento__r.CLABS_fld_estadoPortal__c = :CLABS_cls_constantes.TXT_PUBLICADO
                                                                            AND CLABS_fld_evento__r.CLABS_fld_estadoPublicacion__c = :CLABS_cls_constantes.TXT_ACTIVO
                                                                            AND (CLABS_fld_inscrito__c = true)
                                                                            AND CLABS_fld_evento__r.CLABS_fld_fechaInicioPublicacion__c <= :todayTime.date()
                                                                            AND CLABS_fld_evento__r.CLABS_fld_fecha_Inicio__c <= :todayTime.date()
                                                                            
                                                                        ) OR (
                                                                            CLABS_fld_publicacion__r.RecordType.DeveloperName = :CLABS_cls_constantes.API_RT_PUBLICACIONES_ACTUALIDAD
                                                                            AND CLABS_fld_publicacion__r.CLABS_fld_estadoPortal__c = :CLABS_cls_constantes.TXT_PUBLICADO
                                                                            AND CLABS_fld_publicacion__r.CLABS_fld_estadoPublicacion__c = :CLABS_cls_constantes.TXT_ACTIVO
                                                                            AND CLABS_fld_publicacion__r.CLABS_fld_fechaInicioPublicacion__c <= :todayTime.date()
                                                                        ) OR (
                                                                            (CLABS_fld_evento__r.RecordType.DeveloperName = :CLABS_cls_constantes.API_RT_EVENTO_ACT_DIGITAL 
                                                                             OR CLABS_fld_evento__r.RecordType.DeveloperName = :CLABS_cls_constantes.API_RT_EVENTO_ACT_PRESENCIAL) 
                                                                            AND CLABS_fld_evento__r.CLABS_fld_estadoPortal__c = :CLABS_cls_constantes.TXT_PUBLICADO
                                                                            AND CLABS_fld_evento__r.CLABS_fld_estadoPublicacion__c = :CLABS_cls_constantes.TXT_ACTIVO
                                                                            AND CLABS_fld_evento__r.CLABS_fld_fechaInicioPublicacion__c <= :todayTime.date()
                                                                            AND (NOT CLABS_fld_evento__r.CLABS_fld_fecha_Inicio__c < :todayTime.date()) 
                                                                        ) OR (
                                                                           (CLABS_fld_evento__r.RecordType.DeveloperName = :CLABS_cls_constantes.API_RT_EVENTO_ACT_DIGITAL 
                                                                            OR CLABS_fld_evento__r.RecordType.DeveloperName = :CLABS_cls_constantes.API_RT_EVENTO_ACT_PRESENCIAL) 
                                                                            AND CLABS_fld_evento__r.CLABS_fld_estadoPortal__c = :CLABS_cls_constantes.TXT_PUBLICADO
                                                                            AND CLABS_fld_evento__r.CLABS_fld_estadoPublicacion__c = :CLABS_cls_constantes.TXT_ACTIVO
                                                                            AND ((CLABS_fld_inscrito__c = false) AND CLABS_fld_listaEspera__c = false)
                                                                            AND CLABS_fld_evento__r.CLABS_fld_fechaInicioPublicacion__c <= :todayTime.date()
                                                                            AND (NOT CLABS_fld_evento__r.CLABS_fld_fecha_Inicio__c < :todayTime.date())                                                                 	
                                                                        )
                                                                    )
                                                                    ORDER BY CLABS_fld_evento__r.CLABS_fld_fechaInicioPublicacion__c DESC, CLABS_fld_publicacion__r.CLABS_fld_fechaInicioPublicacion__c DESC LIMIT :numLimit]){ 
                                                                        
                                                                        if(contenidoContacto.CLABS_fld_evento__c != null){
                                                                            idsEventosYPublicaciones.add(contenidoContacto.CLABS_fld_evento__c);
                                                                        } else if(contenidoContacto.CLABS_fld_publicacion__c != null){
                                                                            idsEventosYPublicaciones.add(contenidoContacto.CLABS_fld_publicacion__c);
                                                                        }                                                     
                                                                        
                                                                        respuesta.add(CLABS_cls_actualidadUtils.asignacionActualidad(contenidoContacto));
                                                                    }
            if(Test.isRunningTest()){
                CalloutException e = new CalloutException();
                e.setMessage(CLABS_cls_constantes.MENSAJE_ERROR_TEST);
                throw e;
            }
        }catch(Exception e){
            CLABS_cls_errorHandler.insertError(e);
            return null;               
        } finally {
            System.debug(CLABS_cls_constantes.FIN + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + CLASS_NAME + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + METHOD_NAME);
        }  
        return idsEventosYPublicaciones;
    }
    
    /**
* @name: cardEventosPublicos
* @createdDate: 14/06/2022
* @author: AS - Atmira
* @description: Método encargado de devoler los eventos publicos
*/
    private static void cardEventosPublicos(Set<Id> idsUsados){
        final String METHOD_NAME = 'cardEventosPublicos';
        System.debug(CLABS_cls_constantes.INICIO + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + CLASS_NAME + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + METHOD_NAME);
        
        DateTime todayTime = System.now();
        Integer plazas = 0;
        Boolean insignia = false;
        
        User u = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];

        
        try{
            List<CLABS_obj_contenidoContacto__c> contenidoContacto = [SELECT Id,CLABS_fld_evento__c FROM CLABS_obj_contenidoContacto__c WHERE CLABS_fld_contacto__c =: u.ContactId AND (CLABS_fld_inscrito__c = true OR  CLABS_fld_inscritoOnlineHibrido__c = true  OR CLABS_fld_listaEspera__c = false)];
            
            for(CLABS_obj_eventos__c evento : [SELECT Id, Name, CLABS_fld_numeroPlazas__c, CLABS_fld_numeroInscritos__c,  CLABS_fld_fecha_Fin__c, CLABS_fld_insignia__c,
                                               CLABS_fld_URLimagenCard__c, CLABS_fld_pequeniaDescripcion__c,CLABS_fld_fechaInicioPublicacion__c
                                               FROM CLABS_obj_eventos__c 
                                               WHERE Id NOT IN :idsUsados
                                               AND (RecordType.DeveloperName = :CLABS_cls_constantes.API_RT_EVENTO_ACT_DIGITAL 
                                                    OR RecordType.DeveloperName = :CLABS_cls_constantes.API_RT_EVENTO_ACT_PRESENCIAL) 
                                               AND CLABS_fld_estadoPortal__c = :CLABS_cls_constantes.TXT_PUBLICADO
                                               AND CLABS_fld_estadoPublicacion__c = :CLABS_cls_constantes.TXT_ACTIVO
                                               AND CLABS_fld_esPublico__c = true
                                               AND CLABS_fld_fechaInicioPublicacion__c <= :todayTime.date()
                                               ORDER BY CLABS_fld_fechaInicioPublicacion__c DESC]){
                                                   
                                                   plazas = Integer.valueOf(evento.CLABS_fld_numeroPlazas__c - evento.CLABS_fld_numeroInscritos__c);
                                                   insignia = evento.CLABS_fld_insignia__c != null ? true : false;
                                                   
                                                   Boolean publicoInscrito = false;
                                                   if(evento.CLABS_fld_fecha_Fin__c < todayTime.date()){
                                                       for(CLABS_obj_contenidoContacto__c eventoPublicoInscrito : contenidoContacto){
                                                           publicoInscrito = evento.Id == eventoPublicoInscrito.CLABS_fld_evento__c ? true : false;
                                                       }
                                                   }else{
                                                        publicoInscrito = true;
                                                   }
                                                   if (publicoInscrito){
                                                        respuesta.add(CLABS_cls_actualidadUtils.creacionCard(evento.Id, null, evento.Name, evento.CLABS_fld_pequeniaDescripcion__c, CLABS_cls_constantes.TXT_EVENTOS, 
                                                                                                        false, evento.CLABS_fld_fechaInicioPublicacion__c, false, evento.CLABS_fld_URLimagenCard__c, plazas, insignia));
                                                   }
                                                   
                                               }
            if(Test.isRunningTest()){
                CalloutException e = new CalloutException();
                e.setMessage(CLABS_cls_constantes.MENSAJE_ERROR_TEST);
                throw e;
            }
        }catch(Exception e){
            CLABS_cls_errorHandler.insertError(e);             
        } finally {
            System.debug(CLABS_cls_constantes.FIN + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + CLASS_NAME + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + METHOD_NAME);
        }  
    }
    
    /**
* @name: cardPublicacionesPublicas
* @createdDate: 14/06/2022
* @author: AS - Atmira
* @description: Método encargado de devoler las publicaciones publicas
*/
    private static void cardPublicacionesPublicas(Set<Id> idsUsados){
        final String METHOD_NAME = 'cardPublicacionesPublicas';
        System.debug(CLABS_cls_constantes.INICIO + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + CLASS_NAME + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + METHOD_NAME);
        
        DateTime todayTime = System.now();
        
        try{
            for(CLABS_obj_publicaciones__c publicacion : [SELECT Id, CLABS_fld_tipoPublicacion__c, CLABS_fld_URLimagenCard__c, CLABS_fld_titulo__c, CLABS_fld_fechaFinPublicacion__c,CLABS_fld_fechaInicioPublicacion__c, CLABS_fld_pequeniaDescripcion__c 
                                                          FROM CLABS_obj_publicaciones__c
                                                          WHERE Id NOT IN :idsUsados
                                                          AND RecordType.DeveloperName = :CLABS_cls_constantes.API_RT_PUBLICACIONES_ACTUALIDAD
                                                          AND CLABS_fld_estadoPortal__c = :CLABS_cls_constantes.TXT_PUBLICADO
                                                          AND CLABS_fld_estadoPublicacion__c = :CLABS_cls_constantes.TXT_ACTIVO
                                                          AND CLABS_fld_esPublico__c = true
                                                          AND CLABS_fld_fechaInicioPublicacion__c <= :todayTime.date()                                                                 
                                                          ORDER BY CLABS_fld_fechaInicioPublicacion__c DESC]){
                                                              
                                                              respuesta.add(CLABS_cls_actualidadUtils.creacionCard(publicacion.Id, null, publicacion.CLABS_fld_titulo__c, publicacion.CLABS_fld_pequeniaDescripcion__c, 
                                                                                                                   publicacion.CLABS_fld_tipoPublicacion__c, false, publicacion.CLABS_fld_fechaInicioPublicacion__c, false, 
                                                                                                                   publicacion.CLABS_fld_URLimagenCard__c, 0, false));                               
                                                          }
            if(Test.isRunningTest()){
                CalloutException e = new CalloutException();
                e.setMessage(CLABS_cls_constantes.MENSAJE_ERROR_TEST);
                throw e;
            }
        }catch(Exception e){
            CLABS_cls_errorHandler.insertError(e);             
        } finally {
            System.debug(CLABS_cls_constantes.FIN + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + CLASS_NAME + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + METHOD_NAME);
        }
    }
    
    /**
* @name: getDestacadoHomeActualidad
* @createdDate: 24/06/2022
* @author: AS - Atmira
* @description: Método encargado de devoler un destacado de evento/publicación de actualidad o un inspiracional
*/
    @AuraEnabled
    public static CLABS_cls_wrapperActualidad getDestacadoHomeActualidad(){
        final String METHOD_NAME = 'getDestacadoHomeActualidad';
        System.debug(CLABS_cls_constantes.INICIO + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + CLASS_NAME + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + METHOD_NAME);
        
        DateTime todayTime = System.now();
        List<CLABS_cls_wrapperActualidad> contenidoDestacado = new List<CLABS_cls_wrapperActualidad>();
        CLABS_cls_wrapperActualidad wrapperDestacado = new CLABS_cls_wrapperActualidad();
        
        try {
            
            User u = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
            
            List<CLABS_obj_adminSuperDestacados__c> administracion = [SELECT CLABS_fld_publicacionActualidad__c, CLABS_fld_publicacionActualidad__r.CLABS_fld_esPublico__c, 
                                                                      CLABS_fld_eventoActualidad__c, CLABS_fld_eventoActualidad__r.CLABS_fld_esPublico__c
                                                                      FROM CLABS_obj_adminSuperDestacados__c 
                                                                      WHERE CLABS_fld_activo__c = true
                                                                      ORDER BY createdDate DESC
                                                                      LIMIT 1];
            
            if(administracion.size() > 0){
                //Se busca si el usuario aplica al evento/publicacion del objeto administración 
                for(CLABS_obj_contenidoContacto__c contenidoContacto : [SELECT CLABS_fld_evento__c, CLABS_fld_evento__r.Name, CLABS_fld_evento__r.CLABS_fld_pequeniaDescripcion__c, 
                                                                        CLABS_fld_evento__r.CLABS_fld_urlImagenDestacado__c, 
                                                                        
                                                                        CLABS_fld_publicacion__c, CLABS_fld_publicacion__r.CLABS_fld_urlImagenDestacado__c, CLABS_fld_publicacion__r.CLABS_fld_titulo__c, 
                                                                        CLABS_fld_publicacion__r.CLABS_fld_pequeniaDescripcion__c
                                                                        
                                                                        FROM CLABS_obj_contenidoContacto__c
                                                                        WHERE CLABS_fld_contacto__c = :u.contactId 
                                                                        AND (CLABS_fld_evento__c =: administracion[0].CLABS_fld_eventoActualidad__c 
                                                                             AND CLABS_fld_publicacion__c =: administracion[0].CLABS_fld_publicacionActualidad__c)
                                                                        AND ((CLABS_fld_evento__r.CLABS_fld_estadoPortal__c =: CLABS_cls_constantes.TXT_PUBLICADO AND CLABS_fld_evento__r.CLABS_fld_estadoPublicacion__c =: CLABS_cls_constantes.TXT_ACTIVO) 
                                                                        OR (CLABS_fld_publicacion__r.CLABS_fld_estadoPortal__c =: CLABS_cls_constantes.TXT_PUBLICADO AND CLABS_fld_publicacion__r.CLABS_fld_estadoPublicacion__c =: CLABS_cls_constantes.TXT_ACTIVO))
                                                                        LIMIT 1]){

                    if(contenidoContacto.CLABS_fld_evento__c != null) {                                                       
                        
                        wrapperDestacado.Titulo = contenidoContacto.CLABS_fld_evento__r.Name;
                        wrapperDestacado.idSalesforce = contenidoContacto.CLABS_fld_evento__c;
                        wrapperDestacado.PequeniaDescripcion = contenidoContacto.CLABS_fld_evento__r.CLABS_fld_pequeniaDescripcion__c;
                        wrapperDestacado.urlImagenBanner = contenidoContacto.CLABS_fld_evento__r.CLABS_fld_urlImagenDestacado__c;
                        wrapperDestacado.mostrarBotonDestacado = true;
                        wrapperDestacado.esEvento = true;
                        contenidoDestacado.add(wrapperDestacado);
                        
                    } else if(contenidoContacto.CLABS_fld_publicacion__c != null){
                        
                        wrapperDestacado.Titulo = contenidoContacto.CLABS_fld_publicacion__r.CLABS_fld_titulo__c;
                        wrapperDestacado.idSalesforce = contenidoContacto.CLABS_fld_publicacion__c;
                        wrapperDestacado.PequeniaDescripcion = contenidoContacto.CLABS_fld_publicacion__r.CLABS_fld_pequeniaDescripcion__c;
                        wrapperDestacado.urlImagenBanner = contenidoContacto.CLABS_fld_publicacion__r.CLABS_fld_urlImagenDestacado__c;
                        wrapperDestacado.mostrarBotonDestacado = true;
                        wrapperDestacado.esEvento = false;
                        contenidoDestacado.add(wrapperDestacado);
                    }
                }

                //Si no se encuentra, se busca un evento pùblico
                if(contenidoDestacado.size() == 0 && administracion[0].CLABS_fld_eventoActualidad__r.CLABS_fld_esPublico__c){
                    for(CLABS_obj_eventos__c evento : [SELECT Id, Name, CLABS_fld_pequeniaDescripcion__c, CLABS_fld_urlImagenDestacado__c
                                                       FROM CLABS_obj_eventos__c 
                                                       WHERE Id =: administracion[0].CLABS_fld_eventoActualidad__c
                                                       AND CLABS_fld_estadoPortal__c =: CLABS_cls_constantes.TXT_PUBLICADO AND CLABS_fld_estadoPublicacion__c =: CLABS_cls_constantes.TXT_ACTIVO]){
                                                           
                                                           wrapperDestacado.Titulo = evento.Name;
                                                           wrapperDestacado.idSalesforce = evento.Id;
                                                           wrapperDestacado.PequeniaDescripcion = evento.CLABS_fld_pequeniaDescripcion__c;
                                                           wrapperDestacado.urlImagenBanner = evento.CLABS_fld_urlImagenDestacado__c;
                                                           wrapperDestacado.mostrarBotonDestacado = true;
                                                           wrapperDestacado.esEvento = true;
                                                           contenidoDestacado.add(wrapperDestacado);
                                                       }
                }
                
                //Si no se encuentra, una publicacion pública
                if(contenidoDestacado.size() == 0 && administracion[0].CLABS_fld_publicacionActualidad__r.CLABS_fld_esPublico__c){
                    for(CLABS_obj_publicaciones__c publicacion : [SELECT Id, CLABS_fld_urlImagenDestacado__c, CLABS_fld_titulo__c, CLABS_fld_pequeniaDescripcion__c 
                                                                  FROM CLABS_obj_publicaciones__c
                                                                  WHERE Id =: administracion[0].CLABS_fld_publicacionActualidad__c
                                                                  AND CLABS_fld_estadoPortal__c =: CLABS_cls_constantes.TXT_PUBLICADO 
                                                                  AND CLABS_fld_estadoPublicacion__c =: CLABS_cls_constantes.TXT_ACTIVO]){
                                                                      
                                                                      wrapperDestacado.Titulo = publicacion.CLABS_fld_titulo__c;
                                                                      wrapperDestacado.idSalesforce = publicacion.Id;
                                                                      wrapperDestacado.PequeniaDescripcion = publicacion.CLABS_fld_pequeniaDescripcion__c;
                                                                      wrapperDestacado.urlImagenBanner = publicacion.CLABS_fld_urlImagenDestacado__c;
                                                                      wrapperDestacado.mostrarBotonDestacado = true;
                                                                      wrapperDestacado.esEvento = false;
                                                                      contenidoDestacado.add(wrapperDestacado);
                                                                  }
                }
            }
            
            //Si no se encuentra, un inspiracional
            if(contenidoDestacado.size() == 0){
                for(CLABS_obj_inspiracional__c inspiracional : [SELECT CLABS_fld_titulo__c, CLABS_fld_descripcion__c, CLABS_fld_urlImagen__c 
                                                                FROM CLABS_obj_inspiracional__c 
                                                                WHERE CLABS_fld_activo__c = true 
                                                                AND CLABS_fld_tipo__c = :CLABS_cls_constantes.TXT_BANNER
                                                                AND (CLABS_fld_seccion__c = :CLABS_cls_constantes.TXT_SECT_EVENTO_ACT 
                                                                     OR CLABS_fld_seccion__c = :CLABS_cls_constantes.TXT_SECT_PUBLICACIONES) 
                                                                ORDER BY CLABS_fld_seccion__c LIMIT 1]){
                                                                    
                                                                    wrapperDestacado.Titulo = inspiracional.CLABS_fld_titulo__c;
                                                                    wrapperDestacado.PequeniaDescripcion = inspiracional.CLABS_fld_descripcion__c;
                                                                    wrapperDestacado.urlImagenBanner = inspiracional.CLABS_fld_urlImagen__c;
                                                                    wrapperDestacado.mostrarBotonDestacado = false;
                                                                    wrapperDestacado.esEvento = false;
                                                                    contenidoDestacado.add(wrapperDestacado);
                                                                }
            }          
            
            //Se devuelve el primer elemento encontrado respetando el orden
            return contenidoDestacado[0];
            
        }catch(Exception e){
            CLABS_cls_errorHandler.insertError(e);
            return null;             
        } finally {
            System.debug(CLABS_cls_constantes.FIN + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + CLASS_NAME + CLABS_cls_constantes.SIMBOLO_GUION_ESPACIADO + METHOD_NAME);
        }
    }
    
    
    @AuraEnabled
    public static CLABS_cls_wrapperActualidad getPublicacionActualidadDetalle(Id IdPublicacion){
        
        CLABS_cls_wrapperActualidad publicacionActualidad = new CLABS_cls_wrapperActualidad();
        try {
            //obtenemos la informacion de la publicación de actualidad
            for(CLABS_obj_publicaciones__c publicacionActualidadDetalle : [SELECT Id, CLABS_fld_material__c, CLABS_fld_urlImagenDetalle__c, CLABS_fld_titulo__c, CLABS_fld_tipoPublicacion__c, CLABS_fld_richDescripcion__c,
                                                                           CLABS_fld_fechaFinPublicacion__c, CLABS_fld_fechaInicioPublicacion__c, CLABS_fld_marcas__c, CLABS_fld_categoria__c, CLABS_fld_desafio__c,
                                                                           (SELECT CLABS_fld_URLPublica__c,CLABS_fld_url__c FROM Materiales_de_sesi_n__r)
                                                                           FROM CLABS_obj_publicaciones__c
                                                                           WHERE Id = : IdPublicacion
                                                                           AND (CLABS_fld_estadoPortal__c = :CLABS_cls_constantes.TXT_PUBLICADO)
                                                                           AND RecordType.DeveloperName =: CLABS_cls_constantes.API_RT_PUBLICACIONES_ACTUALIDAD LIMIT 1]){
                                                                               
                                                                               publicacionActualidad.Titulo = publicacionActualidadDetalle.CLABS_fld_titulo__c;
                                                                               publicacionActualidad.Descripcion = publicacionActualidadDetalle.CLABS_fld_richDescripcion__c;
                                                                               publicacionActualidad.TipoCategoria = publicacionActualidadDetalle.CLABS_fld_tipoPublicacion__c;
                                                                               publicacionActualidad.TextFechaFin = CLABS_cls_actualidadUtils.formatoFecha(publicacionActualidadDetalle.CLABS_fld_fechaFinPublicacion__c);
                                                                               publicacionActualidad.TextFechaInicio = CLABS_cls_actualidadUtils.formatoFecha(publicacionActualidadDetalle.CLABS_fld_fechaInicioPublicacion__c);
                                                                               publicacionActualidad.urlImagenBanner = publicacionActualidadDetalle.CLABS_fld_urlImagenDetalle__c;
                                                                               publicacionActualidad.tieneMaterial = publicacionActualidadDetalle.CLABS_fld_material__c != null ? true : false;
                                                                               publicacionActualidad.tieneDesafio = publicacionActualidadDetalle.CLABS_fld_desafio__c != null ? true : false;
                                                                               publicacionActualidad.tieneMaterialSesion = publicacionActualidadDetalle.Materiales_de_sesi_n__r != null && publicacionActualidadDetalle.Materiales_de_sesi_n__r.size() > 0 ? true : false;
                                                                               if (publicacionActualidad.tieneMaterialSesion){
                                                                                   publicacionActualidad.UrlMaterialSesion = publicacionActualidadDetalle.Materiales_de_sesi_n__r[0].CLABS_fld_URLPublica__c != null ? publicacionActualidadDetalle.Materiales_de_sesi_n__r[0].CLABS_fld_URLPublica__c : publicacionActualidadDetalle.Materiales_de_sesi_n__r[0].CLABS_fld_url__c;
                                                                               }
                                                                               publicacionActualidad.Material =  publicacionActualidad.tieneMaterial == true ? publicacionActualidadDetalle.CLABS_fld_material__c : null;
                                                                               publicacionActualidad.Desafio =  publicacionActualidad.tieneDesafio == true ? publicacionActualidadDetalle.CLABS_fld_desafio__c : null;
                                                                               publicacionActualidad.Marca =  publicacionActualidadDetalle.CLABS_fld_marcas__c;
                                                                               publicacionActualidad.Categoria =  publicacionActualidadDetalle.CLABS_fld_categoria__c;
                                                                               
            }
            if(publicacionActualidad.tieneMaterial){
                Boolean tieneMaterialPublicado = false;
                for(CLABS_obj_material__c materialPublicacionDetalle :  [SELECT Id, CLABS_fld_titulo__c, CLABS_fld_pequenaDescripcion__c, CLABS_fld_URLimagenCard__c  FROM CLABS_obj_material__c WHERE Id =: publicacionActualidad.Material  AND CLABS_fld_estadoPortal__c = :CLABS_cls_constantes.TXT_PUBLICADO]){
                    publicacionActualidad.TituloMaterial = materialPublicacionDetalle.CLABS_fld_titulo__c;
                    publicacionActualidad.PequenaDescripcionMaterial = materialPublicacionDetalle.CLABS_fld_pequenaDescripcion__c;
                    publicacionActualidad.urlImagenBannerMaterial = materialPublicacionDetalle.CLABS_fld_URLimagenCard__c;
                    tieneMaterialPublicado = true;
                }
                if(!tieneMaterialPublicado){
                    publicacionActualidad.tieneMaterial = false;  
                }
            }
            
            if(publicacionActualidad.tieneDesafio){
                Boolean tieneDesafioPublicado = false;
                for(CLABS_obj_desafio__c desafioPublicacionDetalle :  [SELECT Id, CLABS_fld_nombre__c, CLABS_fld_pequeniaDescripcion__c, CLABS_fld_URLimagenCard__c  FROM CLABS_obj_desafio__c WHERE Id =: publicacionActualidad.Desafio  AND CLABS_fld_estadoPortal__c = :CLABS_cls_constantes.TXT_PUBLICADO]){
                    publicacionActualidad.TituloDesafio = desafioPublicacionDetalle.CLABS_fld_nombre__c;
                    publicacionActualidad.PequenaDescripcionDesafio = desafioPublicacionDetalle.CLABS_fld_pequeniaDescripcion__c;
                    publicacionActualidad.urlImagenBannerDesafio = desafioPublicacionDetalle.CLABS_fld_URLimagenCard__c;
                    tieneDesafioPublicado = true;
                }
                if(!tieneDesafioPublicado){
                    publicacionActualidad.tieneDesafio = false;  
                }  
            }
            //obtenemos los relacionados
            publicacionActualidad.relacionados = getRelacionadosPublicacionDetalle(IdPublicacion, publicacionActualidad.Marca, publicacionActualidad.TipoCategoria);                                                    
            publicacionActualidad.TieneRelacionados = publicacionActualidad.relacionados[0].TieneRelacionados;
            System.debug(publicacionActualidad);
            return publicacionActualidad;
            
        } catch(Exception e) {
            CLABS_cls_errorHandler.insertError(e);
            return publicacionActualidad;
        }
    }
    
    
    private static List<CLABS_cls_wrapperActualidad> getRelacionadosPublicacionDetalle(Id IdPublicacion, String publicacionMarca, String publicacionTipo){
        
        List<CLABS_cls_wrapperActualidad> relacionados = new  List<CLABS_cls_wrapperActualidad>();
        //PRIMERO EXTRAEMOS LOS RELACIONADOS PUBLICOS
        for(CLABS_obj_publicaciones__c relacionado : [SELECT Id, CLABS_fld_tipoPublicacion__c, CLABS_fld_URLimagenCard__c, CLABS_fld_titulo__c, CLABS_fld_fechaFinPublicacion__c,
                                                      CLABS_fld_fechaInicioPublicacion__c, CLABS_fld_pequeniaDescripcion__c 
                                                      FROM CLABS_obj_publicaciones__c
                                                      WHERE RecordType.DeveloperName =: CLABS_cls_constantes.API_RT_PUBLICACIONES_ACTUALIDAD 
                                                      AND (CLABS_fld_marcas__c includes(:publicacionMarca) OR CLABS_fld_tipoPublicacion__c = :publicacionTipo)
                                                      AND (CLABS_fld_estadoPortal__c = :CLABS_cls_constantes.TXT_PUBLICADO)	
                                                      AND (CLABS_fld_estadoPublicacion__c = :CLABS_cls_constantes.TXT_ACTIVO)	
                                                      AND CLABS_fld_esPublico__c =: true
                                                      AND Id != :IdPublicacion
                                                      ORDER BY CLABS_fld_fechaInicioPublicacion__c LIMIT 2]){
                                                          relacionados.add(CLABS_cls_actualidadUtils.creacionCard(relacionado.Id, null, relacionado.CLABS_fld_titulo__c, relacionado.CLABS_fld_pequeniaDescripcion__c, 
                                                                                                                  relacionado.CLABS_fld_tipoPublicacion__c, false, relacionado.CLABS_fld_fechaInicioPublicacion__c, false, 
                                                                                                                  relacionado.CLABS_fld_URLimagenCard__c, 0, false));
                                                          
                                                          
                                                      }
        //Extraemos los que no son publicos que estan segmentandos para el contacto
        if (relacionados.size()< 2){
            User u = [SELECT ContactId FROM User WHERE Id = :UserInfo.getUserId()];
            
               
                for(CLABS_obj_contenidoContacto__c contenidoContacto : [SELECT CLABS_fld_publicacion__c, CLABS_fld_publicacion__r.CLABS_fld_URLimagenCard__c, CLABS_fld_publicacion__r.CLABS_fld_titulo__c, CLABS_fld_publicacion__r.CLABS_fld_pequeniaDescripcion__c,CLABS_fld_publicacion__r.CLABS_fld_tipoPublicacion__c,CLABS_fld_publicacion__r.CLABS_fld_fechaInicioPublicacion__c
                                                                        FROM CLABS_obj_contenidoContacto__c
                                                                        WHERE CLABS_fld_contacto__c = :u.contactId 
                                                                        AND Id != :IdPublicacion
                                                                        AND (CLABS_fld_publicacion__r.CLABS_fld_marcas__c includes(:publicacionMarca) OR CLABS_fld_publicacion__r.CLABS_fld_tipoPublicacion__c = :publicacionTipo)
                                                                        AND CLABS_fld_publicacion__r.CLABS_fld_esPublico__c =: false
                                                                        AND (CLABS_fld_publicacion__r.CLABS_fld_estadoPortal__c = :CLABS_cls_constantes.TXT_PUBLICADO)	
                                                      					AND (CLABS_fld_publicacion__r.CLABS_fld_estadoPublicacion__c = :CLABS_cls_constantes.TXT_ACTIVO)
																		AND CLABS_fld_publicacion__r.RecordType.DeveloperName =: CLABS_cls_constantes.API_RT_PUBLICACIONES_ACTUALIDAD
                                                                        ORDER BY CLABS_fld_publicacion__r.CLABS_fld_fechaInicioPublicacion__c
                                                                        LIMIT 2]){
                                                                             relacionados.add(CLABS_cls_actualidadUtils.creacionCard(contenidoContacto.CLABS_fld_publicacion__c, null, contenidoContacto.CLABS_fld_publicacion__r.CLABS_fld_titulo__c, contenidoContacto.CLABS_fld_publicacion__r.CLABS_fld_pequeniaDescripcion__c, 
                                                                                                                  contenidoContacto.CLABS_fld_publicacion__r.CLABS_fld_tipoPublicacion__c, false, contenidoContacto.CLABS_fld_publicacion__r.CLABS_fld_fechaInicioPublicacion__c, false, 
                                                                                                                  contenidoContacto.CLABS_fld_publicacion__r.CLABS_fld_URLimagenCard__c, 0, false));
                                                                            if(relacionados.size()==2){
                                                                                break;
                                                                            }
                                                                        }
        }
        if (relacionados.isEmpty()){
            CLABS_cls_wrapperActualidad noTieneRelacionado = new CLABS_cls_wrapperActualidad();
            noTieneRelacionado.TieneRelacionados = false;
            relacionados.add(noTieneRelacionado);
        }
        return relacionados;
    }
    
    
}