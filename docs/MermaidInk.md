# MermaidInk

The function `mermaid-ink` of the Raku package ["WWW::MermaidInk"](https://github.com/antononcube/Raku-WWW-MermaidInk)
gets images corresponding to a Mermaid-js specifications via the web [Mermaid-ink](https://mermaid.ink) interface of [Mermaid-js](https://mermaid.js.org).

----

## Usage

`use WWW::MermaidInk`   
loads the package.

`mermaid-ink($spec)`   
retrieves an image defined by the spec `$spec` from Mermaid's Ink Web interface.

`mermaid-ink($spec format => 'md-image')`   
returns a string that is a Markdown image specification in Base64 format.

`mermaid-ink($spec file => fileName)`   
exports the retrieved image into a specified PNG file.

`mermaid-ink($spec file => Whatever)`   
exports the retrieved image into the file `$*CMD ~ /out.png`.


### Details & Options

- Mermaid lets you create diagrams and visualizations using text and code.

- Mermaid has different types of diagrams: Flowchart, Sequence Diagram, Class Diagram, State Diagram, Entity Relationship Diagram, User Journey, Gantt, Pie Chart, Requirement Diagram, and others. It is a JavaScript based diagramming and charting tool that renders Markdown-inspired text definitions to create and modify diagrams dynamically.

- `mermaid-ink` uses the Mermaid's functionalities via the Web interface "https://mermaid.ink/img".

- The first argument can be a string (that is, a mermaid-js specification) or a list of pairs.

- The option "directives" can be used to control the layout of Mermaid diagrams if the first argument is a list of pairs.

- `mermaid-ink` produces images only.

-----

## Examples

### Basic Examples

Generate a flowchart from a Mermaid specification:

```raku, results=asis
use WWW::MermaidInk;

'graph TD 
   WL --> |ZMQ|Python --> |ZMQ|WL' 
 ==> mermaid-ink(format=>'md-image')
```

Create a Markdown image expression from a class diagram:

```raku, results=asis
my $spec = q:to/END/;
classDiagram
    Animal <|-- Duck
    Animal <|-- Fish
    Animal <|-- Zebra
    Animal : +int age
    Animal : +String gender
    Animal: +isMammal()
    Animal: +mate()
    class Duck{
        +String beakColor
        +swim()
        +quack()
    }
    class Fish{
        -int sizeInFeet
        -canEat()
    }
    class Zebra{
        +bool is_wild
        +run()
    }
END

mermaid-ink($spec, format=>'md-image')    
```

### Scope

The first argument can be a list of pairs -- the corresponding Mermaid-js graph is produced. 
Here are the edges of directed graph:

```raku, results=asis
my @edges = ['1' => '3', '3' => '1', '1' => '4', '2' => '3', '2' => '4', '3' => '4'];
```

Here is the corresponding mermaid-js image:

```raku, results=asis
mermaid-ink(@edges, format=>'md-image')
```

Here is a left-to-right version:

```raku, results=asis
mermaid-ink(@edges, directive => 'LR', format=>'md-image')
```

### Create a Sequence Diagram

```raku, results=asis
my $spec = q:to/END/;
sequenceDiagram
    Alice->>John: Hello John, how are you?
    John-->>Alice: Great!
    Alice-)John: See you later!
END

mermaid-ink($spec, format=>'md-image')
```

### State diagram

```raku, results=asis
my $spec = q:to/END/; 
stateDiagram-v2
    [*] --> Still
    Still --> [*]

    Still --> Moving
    Moving --> Still
    Moving --> Crash
    Crash --> [*]
END

mermaid-ink($spec, format=>'md-image')    
```


### Entity Relationship Diagram

```raku, results=asis
my $spec = q:to/END/;
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    CUSTOMER }|..|{ DELIVERY-ADDRESS : uses   
END

mermaid-ink($spec, format=>'md-image')    
```


### User Journey 

```raku, results=asis
my $spec = q:to/END/;
journey
    title My working day
    section Go to work
      Make tea: 5: Me
      Go upstairs: 3: Me
      Do work: 1: Me, Cat
    section Go home
      Go downstairs: 5: Me
      Sit down: 5: Me
END

mermaid-ink($spec, format=>'md-image')    
```

## Gantt chart

```raku, results=asis
my $spec = q:to/END/;
gantt
    title A Gantt Diagram
    dateFormat  YYYY-MM-DD
    section Section
    A task           :a1, 2014-01-01, 30d
    Another task     :after a1  , 20d
    section Another
    Task in sec      :2014-01-12  , 12d
    another task      : 24d
END

mermaid-ink($spec, format=>'md-image')    
```

### Pie chart

```raku, results=asis
my $spec = q:to/END/; 
pie title Pets adopted by volunteers
    "Dogs" : 386
    "Cats" : 85
    "Rats" : 15
END

mermaid-ink($spec, format=>'md-image')    
```

### Requirement Diagram

```raku, results=asis
my $spec = q:to/END/;
    requirementDiagram

    requirement test_req {
    id: 1
    text: the test text.
    risk: high
    verifymethod: test
    }

    element test_entity {
    type: simulation
    }

    test_entity - satisfies -> test_req
END

mermaid-ink($spec, format=>'md-image')    
```

-----

## Options

### MermaidDirectives

The option "directives" is used when the first argument is a list of pairs:

```raku, results=asis
SeedRandom[1];
Block[{gr = RandomGraph[{5, 6}]}, 
  Association[# -> my $spec = q:to/END/; gr, "MermaidDirectives" -> #] & /@ {"TB", "TD", "BT", "RL", "LR"}] 
 ]
```

The meaning of Mermaid's flowchart orientation directives are given in the following table:

------

## Applications

Create a Markdown-related conversions flowchart:

```raku, results=asis
my $spec = q:to/END/;
graph TD
    WL[Make a Mathematica notebook] --> E
    E["Examine notebook(s)"] --> M2MD
    M2MD["Convert to Markdown with M2MD"] --> MG
    MG["Convert to Mathematica with Markdown::Grammar"] --> \
|Compare|E
END

mermaid-ink($spec, format=>'md-image')    
```

Create a Sequence Diagram for a blogging app service communication:

```raku, results=asis
my $spec = q:to/END/;
sequenceDiagram
    participant web as Web Browser
    participant blog as Blog Service
    participant account as Account Service
    participant mail as Mail Service
    participant db as Storage

    Note over web,db: The user must be logged in to submit blog posts
    web->>+account: Logs in using credentials
    account->>db: Query stored accounts
    db->>account: Respond with query result

    alt Credentials not found
        account->>web: Invalid credentials
    else Credentials found
        account->>-web: Successfully logged in

        Note over web,db: When the user is authenticated, they can now submit new posts
        web->>+blog: Submit new post
        blog->>db: Store post data

        par Notifications
            blog--)mail: Send mail to blog subscribers
            blog--)db: Store in-site notifications
        and Response
            blog-->>-web: Successfully posted
        end
    end
END

mermaid-ink($spec, format=>'md-image')    
```

------

## Properties and Relations


A diagram that clarifies the execution of `mermaid-ink`:

```raku, results=asis
my $spec = q:to/END/;
graph TD
    UI[/User input/]
    MS{{Mermaid-ink server}}
    Raku{{Raku}}
    MDnb>Markdown document]
    MDIC[[Input cell]]
    MDOC[[Output cell]]
    MI[MermaidInk]
    UI --> MDIC -.- MDnb
    MDIC --> MI -.- Raku
    MI --> |spec|MS
    MS --> |image|MI
    MI --> MDOC -.- MDnb
    WLnb -.- Raku
END

mermaid-ink($spec, format=>'md-image')    
```


For some textual content MermaidInk specifications should use quotes. Also, a new line character in text can be included using "<br/>":   

```raku, results=asis
my $spec = q:to/END/;
graph LR
	A["Complicated text <br/>(maybe)"] --> S[Sink <br/> place]
END

mermaid-ink($spec, format=>'md-image')    
```

Without the quotes for block "A" the specifications above does not work:

```raku, results=asis
my $spec = q:to/END/;
graph LR
	A[Complicated text <br/>(maybe)] --> S[Sink <br/> place]
END

mermaid-ink($spec, format=>'md-image')    
```

-----

## Neat Examples

Larger flowchart with some styling:

```raku, results=asis
my $spec = q:to/END/;
graph TB
    sq[Square shape] --> ci((Circle shape))

    subgraph A
        od>Odd shape]-- Two line<br/>edge comment --> ro
        di{Diamond with <br/> line break} -.-> ro(Rounded<br>square<br>shape)
        di==>ro2(Rounded square shape)
    end

    %% Notice that no text in shape are added here instead that is appended further down
    e --> od3>Really long text with linebreak<br>in an Odd shape]

    %% Comments after double percent signs
    e ((Inner / circle<br>and some odd <br>special characters)) --> f(,.?!+-*ز)

    cyr[Cyrillic]-->cyr2((Circle shape Начало));

     classDef green fill:#9 f6,stroke:#333,stroke-width:2px;
     classDef orange fill:#f96,stroke:#333,stroke-width:4px;
     class sq,e green
     class di orange
END

mermaid-ink($spec, format=>'md-image')    
```


Some interesting interaction:

```raku, results=asis
my $spec = q:to/END/;
sequenceDiagram
    participant Alice
    participant Bob
    Alice->>John: Hello John, how are you?
    loop Healthcheck
        John->>John: Fight against hypochondria
    end
    Note right of John: Rational thoughts <br/>prevail!
    John-->>Alice: Great!
    John->>Bob: How about you?
    Bob-->>John: Jolly good!
END

mermaid-ink($spec, format=>'md-image')    
```

-----

## References

- [GitHub - mermaid-js/mermaid: Generation of diagram and flowchart from text in a similar manner as markdown](https://github.com/mermaid-js/mermaid)

- [mermaid - Markdownish syntax for generating flowcharts, sequence diagrams, class diagrams, gantt charts and git graphs.](https://mermaid-js.github.io/mermaid)

- [GitHub - mermaid-js/mermaid-cli: Command line tool for the Mermaid library](https://github.com/mermaid-js/mermaid-cli)

- [Online FlowChart & Diagrams Editor - Mermaid Live Editor](https://mermaid.live/)
