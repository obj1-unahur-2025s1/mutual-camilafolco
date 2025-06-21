class Actividad {
  const property idiomas = #{}

  method esInteresante() = idiomas.size() > 1
  method sirveParaBroncearse() = true
  method dias()
  method implicaEsfuerzo() = true
  method esRecomendablePara(socio) = true
}

class ViajeDePlaya inherits Actividad {
  const largo 

  override method dias() = largo / 500 
  override method implicaEsfuerzo() = largo > 1200
  override method esRecomendablePara(socio) {
    return
    self.esInteresante() && socio.leAtrae(self) && not socio.acts().contains(self)
  }
}

class ExcursionCiudad inherits Actividad {
  const property cantAtracciones

  override method dias() = cantAtracciones/2
  override method sirveParaBroncearse() = false
  override method implicaEsfuerzo() = cantAtracciones.between(5,8)
  override method esInteresante() = super() || cantAtracciones == 5
}

class ExcursionTropical inherits ExcursionCiudad {
  override method dias() = super() + 1
  override method sirveParaBroncearse() = true
}

class SalidaDeTrekking inherits Actividad {
  const km 
  const diasDeSol

  override method dias() = km/50
  override method implicaEsfuerzo() = km > 80
  override method sirveParaBroncearse() {
    return diasDeSol > 200 || (diasDeSol.between(100,200) && km > 120)
  }
  override method esInteresante() = super() && diasDeSol > 140
}

class ClaseGimnasia inherits Actividad {
  method initialize() {
    idiomas.clear()
    idiomas.add("español")
  }
  method validador() {
    if (!idiomas == #{"español"}) {
      self.error("el unico idioma es español")
    }
  }
  override method dias() = 1
  override method sirveParaBroncearse() = false
  override method esRecomendablePara(socio) {
    return socio.edad().between(20,30)
  }
}

class Socio {
  const property acts  = []
  const maxActs 
  const property idiomas = #{}
  var property edad

  method initialize() {
    acts.clear()
  } 
  method esAdoradordelSol() = acts.all({a=>a.sirveParaBroncearse()})
  method actsEsforzadas() = acts.filter({a=>a.implicaEsfuerzo()})
  method registrarActividad(act) {
    if(maxActs == acts.size()) {
      self.error("se alcanzó el max de actividades")
    } else {
      acts.add(act)
    }
  }
  method leAtrae(act)
}

class SocioTranquilo inherits Socio {
  override method leAtrae(act) = act.dias() >= 4
}

class SocioCoherente inherits Socio {
  override method leAtrae(act) {
    return 
    if (self.esAdoradordelSol()) {
      act.sirveParaBroncearse()
    } else {
      act.implicaEsfuerzo()
    }
  }
}

class SocioRelajado inherits Socio {
  override method leAtrae(act) {
    return
    ! idiomas.intersection(act.idiomas()).isEmpty()
  } 
}

class TallerLiterario inherits Actividad {
  var cantLibros 
  const libros = #{}
  
  override method implicaEsfuerzo() {
    return
    libros.any({l=>l.paginas() > 500}) || libros.all({l=>l.autor() == libros.first().autor()}) && cantLibros > 1
  }
  override method esRecomendablePara(socio) {
    return socio.idiomas().size() > 1
  }
  override method sirveParaBroncearse() = false
  override method dias() = cantLibros + 1
}