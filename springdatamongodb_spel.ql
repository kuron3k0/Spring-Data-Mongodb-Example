/**
 *@name Tainttrack Context lookup
 *@kind path-problem
 */
import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PathGraph

predicate classinstance(DataFlow::Node src, DataFlow::Node sink){
    exists(ClassInstanceExpr cie |
        (
            src.asExpr() = cie.getAnArgument()
            and sink.asExpr() = cie
        )
    )
}

predicate getter_step(DataFlow::Node src, DataFlow::Node sink){
    exists(MethodAccess getm |
        (
            (getm.getMethod() instanceof GetterMethod or getm.getMethod().getName().matches("get%")) and
            sink.asExpr() = getm and 
            src.asExpr() = getm.getQualifier()
        )
    )
}

predicate group_step(DataFlow::Node src, DataFlow::Node sink){
    exists(MethodAccess group |
            sink.asExpr() = group and
            src.asExpr() = group.getQualifier() and
            group.getMethod().getDeclaringType().hasQualifiedName("java.util.regex", "Matcher") and
            group.getMethod().getName() = "group"
    )
}

predicate match_step(DataFlow::Node src, DataFlow::Node sink){
    exists(MethodAccess matcher |
            sink.asExpr() = matcher and
            src.asExpr() = matcher.getAnArgument() and
            matcher.getMethod().getDeclaringType().hasQualifiedName("java.util.regex", "Pattern") and
            matcher.getMethod().getName() = "matcher"
    )
}

class ExecMethod extends Method {
    ExecMethod() {
  
        getName() = "getBindingContext" and
        this.getDeclaringType().hasQualifiedName("org.springframework.data.mongodb.repository.query", "StringBasedMongoQuery")
    }
}


class TainttrackLookup  extends TaintTracking::Configuration {
    
    TainttrackLookup() { 
        this = "TainttrackLookup" 
    }

override predicate isSource(DataFlow::Node source) {
    exists( ExecMethod m| 
     //   source.asExpr() instanceof StringLiteral //and 

      source.asParameter() = m.getAParameter()
        )
}

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma |

      ma.getMethod().getName()="evaluateExpression" and
      sink.asExpr() = ma.getAnArgument() and
      ma.getCaller().getName() = "bindableValueFor" 
      )
  }

  override predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node sink) {

    classinstance(src,sink) or
    getter_step(src, sink) or 
    group_step(src, sink) or
    match_step(src, sink)
}

}

from TainttrackLookup config , DataFlow::PathNode  source, DataFlow::PathNode  sink
where
    config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "mongo spel", source.getNode(), "this is user input"
