/* Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module flow.variable.service.impl.QueryOperator;
import hunt.Enum;
import std.concurrency : initOnce;
/**
 * Used to indicate the operator that should be used to comparing values in a query clause.
 *
 * @author Frederik Heremans
 */
class QueryOperator :AbstractEnum!QueryOperator {

    this(string name, int val)
    {
        super(name, val);
    }

     static QueryOperator  EQUALS() {
       __gshared QueryOperator  inst;
       return initOnce!inst(new QueryOperator("EQUALS" , 0));
     }

    static QueryOperator  NOT_EQUALS() {
      __gshared QueryOperator  inst;
      return initOnce!inst(new QueryOperator("NOT_EQUALS" , 1));
    }

    static QueryOperator  GREATER_THAN() {
      __gshared QueryOperator  inst;
      return initOnce!inst(new QueryOperator("GREATER_THAN" , 2));
    }

    static QueryOperator  GREATER_THAN_OR_EQUAL() {
      __gshared QueryOperator  inst;
      return initOnce!inst(new QueryOperator("GREATER_THAN_OR_EQUAL" , 3));
    }
    static QueryOperator  LESS_THAN() {
      __gshared QueryOperator  inst;
      return initOnce!inst(new QueryOperator("LESS_THAN" , 4));
    }
   static QueryOperator  LESS_THAN_OR_EQUAL() {
     __gshared QueryOperator  inst;
     return initOnce!inst(new QueryOperator("LESS_THAN_OR_EQUAL" , 5));
   }
    static QueryOperator  LIKE() {
      __gshared QueryOperator  inst;
      return initOnce!inst(new QueryOperator("LIKE" , 6));
    }

    static QueryOperator  EQUALS_IGNORE_CASE() {
      __gshared QueryOperator  inst;
      return initOnce!inst(new QueryOperator("EQUALS_IGNORE_CASE" , 7));
    }

     static QueryOperator  NOT_EQUALS_IGNORE_CASE() {
       __gshared QueryOperator  inst;
       return initOnce!inst(new QueryOperator("NOT_EQUALS_IGNORE_CASE" , 8));
     }

   static QueryOperator  LIKE_IGNORE_CASE() {
     __gshared QueryOperator  inst;
     return initOnce!inst(new QueryOperator("LIKE_IGNORE_CASE" , 9));
   }

  static QueryOperator  EXISTS() {
    __gshared QueryOperator  inst;
    return initOnce!inst(new QueryOperator("EXISTS" , 10));
  }

    static QueryOperator  NOT_EXISTS() {
      __gshared QueryOperator  inst;
      return initOnce!inst(new QueryOperator("NOT_EXISTS" , 11));
    }
    //EQUALS, NOT_EQUALS, GREATER_THAN, GREATER_THAN_OR_EQUAL, LESS_THAN, LESS_THAN_OR_EQUAL, LIKE, EQUALS_IGNORE_CASE,
    //NOT_EQUALS_IGNORE_CASE, LIKE_IGNORE_CASE, EXISTS, NOT_EXISTS,
}
