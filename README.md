# **Using Graphics To Effectively Convey Information**
# Case Study: German Company Types
## WWDC23 Swift Student Challenge Submission by Luca Hendrik Jonscher

I always believed in the importance and effectiveness of graphics and imagery as a mean of conveying information. For example, when making posters in school, I always rather drew maps and images, wrote short but effective notes, and focussed on the general design and layout of the material. Instead of relying purely on text, I used icons, as in “􀄾: 612 m” instead of “Length: 612 m.” I always tried putting the least text but the most information on a poster/slide/sheet as possible. Graphics can have a very high information density, without compromising and even exceeding the ability to be understood easily and quickly.

This trait of mine reflects in different aspects of my character, e.g., I love maps, and the way information can be conveyed with it. I love the design and usage of SF Symbols, and wouldn’t want to miss using them. I enjoy editorial design and layouting text meaningfully.

I also used this method in my two former submissions:
*see Assets/README/ for example images*
**Latin Dance**, a playground, where one can learn the basic step of the four Latin Dances (Samba, Cha-cha-cha, Rumba, and Jive):
    – in addition to a short explanatory text for each dance, I showed three emojis that captured the mood and emotions of the dance as well as an illustration of a key pose *see "Latin Dance Dance"*
    – the steps were described with text that could be read out loud; in addition, there were 3D-scenes available that showed the foot positions *see "Latin Dance Step"*
    – the rhythm was displayed in an illustrative way *see "Latin Dance Rhythm"*
**Blockchain**, an app playground that explains how blockchains work, for what they can be used, and their problems/challenges using slide-like pages of information
    – each page had a colorful graphic crafted with SF Symbols that helped explain and visualize the content *see "Blockchain Page Graphic"*
    – blockchain components, e.g, blocks or transactions, were displayed in a simplified, but effective manner; complicated blockchain signatures were indicated with the language-versions of the signature SF Symbol *see "Blockchain Transaction"*
    – there were interactive games that showed how blockchains work *see "Blockchain Game"*
    
## Information About The Project

My father owned a company, I want to found a company in the future, and I enjoy economic topics. Thus, I always wanted to understand, what the different companies—GmbH, KG, GbR, etc.—meant. A GmbH (Limited Liability Partnership) has *limited liability*, and you need at leas 25.000€ capital. That’s easy to know, but what is a GmbH really. In German, “GmbH & Co. KG” is a common phrase when you joke about a company, e.g., there is a children’s show called (translated) “Santa Claus & Co. KG,” . . . but what really *is* a GmbH & Co. KG? I researched it every other year, but wouldn’t really understand it. And then, some months ago, it finally clicked. While reading the Wikipedia articles, my mind formed a visual representation. I read further and made a discovery: different companies are basically just about:
* who manages,
* who is shareholder,
* what is their liability, and
* what capital is there.
Of course, it is much more detailed than that, but that are the crucial things that distinguish the different types of companies. I made research for each company type and wrote notes about each one. During that, I already formed graphics for each of the companies in my head. I already was so hooked on my idea that I planned on making an infographic, because in the whole internet, there is no image that explains the German company forms’ structures. There are diagrams on how to categorize them, sure. But no graphic that tells me, what these companies actually are. When I had my notes ready, I started visualizing my thoughts in Apple Freeform (see Assets/README/Freeform.pdf). The company is visualized as a box that contains the layers of management, shareholders, and capital. Different types are distinguished by color, minimum amounts are adequately noted, and liability is stylized as a full and a dotted arrow. When my idea was ready, I created the infographic in Adobe XD (see Assets/README/Infographic). It shows all German company forms, tidbits of company information, important knowledge about company law, and the laws where the company forms are determined. It is not ready for release yet, but I am sure to finalize it shortly.
The last two years, my Swift Student Challenge both taught something: Latin Dance and blockchains, respectively. I wanted to continue this streak and instantly thought of my infographic. It would be perfect for the digital environment, as touch interactivity makes it even better. 

## Features & Technologies

Technologies:
* SwiftUI
* Charts

Apps used during development:
* Xcode
* SF Symbols
* Pixelmator Pro

Apps used for the infographic:
* Apple Notes
* Apple Freeform
* Adobe XD 

My app playground is an informational app about German forms of companies. It uses a visual layout to represent and explain the companies’ structure—how and by whom the company is managed, the shareholders and their liability, and the capital structure. Instead of conveying the information via text, the company form graphic clearly, simply, and beautifully visualizes the companies’ structure. This approach makes it much more easy to understand, to remember, and to compare. The graphics make a complicated matter of law clear and concise. Furthermore, the graphic shows the company form’s abbreviation, name, translation, if available their reason, and if available an additional tidbit of information. Companies that have alternative structures are displayed in a tab view, so that it is easy to switch between them. All the different types of companies (that are categorized by their type) can be viewed in one of two ways: (1), a typical list view, or (2) the ”Carousel” view, where each section consists of a horizontal scrolling view that shows a stylized representation of the company form graphic; when tapping the section header, one can view a vertical scroll view of all company form graphics. Mixed forms (companies that have another company as management or shareholder) are also listed. There is a special ”Mixed Forms Builder”, where one can try out different company variations. 
The app playground is build on SwiftUI to create its views. The company structure uses a declarative syntax, inspired by SwiftUI. The company data models are build on core Swift language features. I achieved a lightweight data and UI structure for a complicated topic. German company statistics are easily and beautifully displayed using the Charts framework. 

## Challenges & Successes

When I created the data models for `Company` (`CompanyStructure`, `CompanyLayer`, etc.) I went through multiple revision and refactoring stages, where I refined and improved the structure. I restructured the different `init`s multiple times, deciding between defining them on the protocol or the structure level. In the end, I decided for structure-specific initializers, because then I am able to define them specifically for the use cases for each layer. Instead of liability being a separate, and thus more cluttered, layer, I refactored liability to be a modifier for company layers.

While graphics can be incredibly use- and helpful for many people, they exclude people with visual and cognitive disabilities. A textual representation that can be read or spoken out loud is needed for these cases. Due to time issues, I was not able to thoroughly test and adapt the company info graphics for this.

I am happy how the company data model turned out. I especially like the declarative syntax, as it is another layer of visualization instead of blank text. Furthermore, I like how the design of the infographic turned out.

## Beyond WWDC

I have multiple Swift development tutorials posted on Medium (https://medium.com/@lucajonscher). As of now, all articles had 125,000 views and 55,000 reads. I am glad that I am able to help other developers this way.

## Comments

I am deeply interested in development and design. Creating visual stunning content is my passion. I want to help making content of all kind look more appealing and beautiful, more accessible, and have a better user experience. I dream of a design/development job at Apple and/or a freelancer/startup career. I want to meet new people and create new things together. I want to make a good influence on the world via design. 
Apple is a big factor in my designer mind. Although since my childhood I was fond of aesthetics, Apple, its products, and its design philosophy were a large catalyst in me becoming a designer. 
