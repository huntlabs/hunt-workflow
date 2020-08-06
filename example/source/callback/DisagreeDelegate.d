module callback.DisagreeDelegate;

import flow.engine.deleg.DelegateExecution;
import flow.engine.deleg.JavaDelegate;
import hunt.String;
import std.stdio;

class DisagreeDelegate : JavaDelegate
{
    void execute(DelegateExecution execution)
    {
      writefln("%s disagree %s's order" , (cast(String)(execution.getVariable("manager"))).value, (cast(String)(execution.getVariable("employee"))).value);
    }
}

