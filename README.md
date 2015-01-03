HerbGobbler: Ruby on Rails internationalization (i18n) and localization text extraction tool
==========================

HerbGobbler is a software localization tool for Ruby on Rails based websites seeking to translate their website into multiple languages.  It aims to assist businesses and localization services with website internationalization.  The HerbGobbler enables software internationalization of Ruby on Rails based websites by:

* Parsing a projects Rails Template Code</li>
* Extracting the language specific text</li>
* Combining the text into full sentences for optimal translations</li>
* Moving the text into an localized datastore (Rails YML files by default)</li>
* Replace the language specific text in the Rails Template Code with the Rails method calls(t) to retrieve the text in the desired language</li>

By automating the text extraction process in software internationalization, the HerbGobbler increases quality of the final foreign language translation by implementing industry best practices, while at the same time decreasing the number of bugs that normally occur in the time consuming and tedious foreign localization process.  

HerbGobbler Turns This
--------------------
<pre>
&lt;div class="bullet"> 
  &lt;div class="description"> 
     If you're on an old version of Rubygems
     (before 1.3.6)
  &lt;/div> 
  &lt;pre class='sunburst'>Run: $ gem update --system&#x000A;&lt;/pre> 
&lt;div> 
</pre>

Into This
--------
<pre>
&lt;div class="bullet"> 
  &lt;div class="description"> 
    &lt;%= t '.if_you_re_on' %>
  &lt;/div> 
  &lt;pre class='sunburst'>$ &lt;%= t '.run_gem_update' %>&lt;/pre> 
&lt;div> 
</pre>
Getting Started
----------
Getting started with the HerbGobbler is easy:

          $ gem install herbgobbler

If you're on an old version of Rubygems (before 1.3.6)
          
          $ gem update --system

Extract all of the text from your Rails Project
---------------------
Use the gobble command to extract all the english text from your .erb files and place the extracted text into the RAILS_ROOT/config/locals/en.yml file

          $ gobble i18n -a ~/my/rails/root/

The HerbGobbler is very much beta software.  It attempts to implement the best practices in internationalization (i18n) and localization by extracting complete sentences (even when these sentences contain html).  If you discover a piece of text that is not being properly extracted, or a pattern of extraction that you think is incorrect, please enter a bug into the system and a patch will be issued.  

Experimental TR8N Support
-------------------------
The Herbgobbler also has experimental <a href="https://github.com/tr8n/tr8n">tr8n</a> support.  By running:
          $ gobble -tr8n -a ~/my/rails/root

The Herbgobbler will rewrite your erb files with tr8n embed (tr) tags.  This is a more beta feature than the rest of the Herbgobbler.  If you discover any problems please submit a bug through github being sure to include the block of erb that is causing problems.

Command Line Options
--------------------
HerbGobbler provides several command line options to make text extraction simppler
* -a / --path : Defines the root of the Rails project
* -e / --extension : Defines the extension of the files that will be converted, without a preceeding period.
* -f / --file : Defines a single file to extract text from

Customizing the HerbGobbler
----------------------------
If you are interested in exporting text to a different data store than the default rails i18n format (en.yml), this can be done by implementing a <a href="https://github.com/douglasjsellers/herbgobbler/blob/master/lib/core/base_translation_store.rb">TranslationStore</a>.  
