## Frameworks
### Language
There are many languages to choose from with many considerations.  To name a few (Java, C#, Python, Ruby, Javascript) any maninstream language could potentially be a good candidate to use for QA automation.<br>
<br>
We chose to use **Ruby** as our language of choice.  A few reasons for this consideration:
* OOP - This is a fully supported object oriented language.  Has support for code re-usability and encapsulation.
* Run-time Environment - Ruby runs inside of a managed environment, so the code that is written on a Windows machine will perform exactly the same on a Linux machine.
* Loosely Typed Language - Ruby is a loosely typed language, the advantage is a bit more ease with script development not having to worry about strongly typing the code.
* Interpolated vs Compiled - Since Ruby is an interpolated language it allows us to make any changes to our code and it will be updated immediately as opposed to having to run the code through a compiler and build process with compiled languages such as C# or Java.
* Licensing - Ruby has a GNU license which allows it to be freely used for commercial purposes.  In comparison to C# which would require every machine the code is executed on to have a paid Windows license, automation code written in Ruby would have no cost overhead aside from hardware.
* Foundational Knowledge - We have been using Ruby as a QA automation group for the last 2 years so we have a great deal of knowledge relating to other Ruby frameworks and language specifics. 

### Web Driver
**Watir** will be the web driver used for QA automation.  Firstly what is a web driver and why do we need it?  As we create automation scripts, we need a way to have our scripts interact with the web applications.  Such as, clicking a button on web application and testing its behavior.  A web driver allows this interaction by directly hooking into the browser.<br>
<br>
Here are few reasons the Watir library was chosen:
* Watir is wrapper around Selenium.  So this really means that when you use Watir you ARE using Selenium.  Even though the group that created Selenium offers Ruby bindings, Watir wraps Selenium so it can be used in very similar ways as other languages such as C# or Java allow you to interact.
* Because Selenium is probably the most widely used web driver on the market we have a high degree of confidence in the library being maintained and updated
* Licensing - there is no cost to commercially use Watir/Selenium so we can deploy our solution and have no additional cost overhead
* Maturity - Because Watir/Selenium has been around for quite some time, the documentation and examples found online are outstanding.
* Browser Compatibility - Selenium supports all major browsers but specifically for QA automation we will be supporting (IE/Edge, Chrome, Firefox).

### Test Framework
**RSpec** has been chosen to execute tests.  A few features of RSpec is what drove this descision:
* Natively written in Ruby
* Because of the widespread use there is a lot of great documentation and advanced plugins written
* Provides native HTML report generation
* Has a BDD interface for writing tests which also reflects in reporting
* Supports "tagging" which will allow us to design tests to be ran in one more multiple tests suites

### Application Native Libraries
TBD