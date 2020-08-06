module callback.AgreeDelegate;

import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.JavaDelegate;
import hunt.String;
import std.stdio;

class AgreeDelegate : JavaDelegate
{
    void execute(DelegateExecution execution)
    {
       writefln("%s agree %s's order" , (cast(String)(execution.getVariable("manager"))).value, (cast(String)(execution.getVariable("employee"))).value);
    }
}
