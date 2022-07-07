/**
 * @kind path-problem
 */
import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.DataFlow
import DataFlow::PathGraph
class MyConf extends DataFlow::Configuration {
  MyConf() { this = "MyConf" }
  
  override predicate isSource(DataFlow::Node source) {
    exists(RemoteFlowSource remote | source.asParameter() = remote.asParameter())
  }
override predicate isSink(DataFlow::Node sink) {
    exists(Method c, Annotation ann, MethodAccess ma | ann = c.getAnAnnotation() and (ann.toString() = "Query" or ann.toString() = "Aggregation") and ann.getAValue().toString().regexpMatch(".*\\?[0-9].*")
and ma.getMethod() = c and ma.getAnArgument()
 = sink.asExpr())
  }
}
from MyConf conf, DataFlow::PathNode source, DataFlow::PathNode sink
where conf.hasFlowPath(source, sink)
select sink, source, sink, "SpEL Injection found! - CVE-2022-22980"
