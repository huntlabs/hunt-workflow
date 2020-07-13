module callback.CallExternalSystemDelegate;

import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.JavaDelegate;
import hunt.String;
import std.stdio;

class CallExternalSystemDelegate : JavaDelegate
{
    void execute(DelegateExecution execution)
    {
        writeln("Calling the external system for employee %s" , (cast(String)(execution.getVariable("employee"))).value);
    }
}
