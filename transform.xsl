<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
                xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
                xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
                xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
                xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" 
                xmlns:xlink="http://www.w3.org/1999/xlink" >
    <xsl:output method="text" />

    <!-- Find the title style -->
    <xsl:variable name="titleStyle">
        <xsl:value-of select="descendant::style:style[@style:parent-style-name='Title']/@style:name" />
    </xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates select="office:document-content/office:body/office:text" />
   </xsl:template>

<xsl:template match="text:p[@text:style-name=$titleStyle]">
<!-- Traps heading 1 -->
    <xsl:variable name="underline" select="." />
    <xsl:value-of select="."/>
    <xsl:value-of select="translate($underline,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -','=========================================================')"/>
    <xsl:call-template name="twoNewlines" />
</xsl:template>

<xsl:template match="text:p[@text:style-name='Heading_20_1']">
<!-- Traps heading 2 -->
    <xsl:variable name="underline" select="." />
    <xsl:value-of select="."/>
    <xsl:value-of select="translate($underline,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -','---------------------------------------------------------')"/>
    <xsl:call-template name="twoNewlines" />
</xsl:template>

<xsl:template match="text:p[@text:style-name='Heading_20_2']">
<!-- Traps heading 3 -->
    <xsl:variable name="underline" select="." />
    <xsl:value-of select="."/>
    <xsl:value-of select="translate($underline,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -','~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')"/>
    <xsl:call-template name="twoNewlines" />
</xsl:template>

<xsl:template match="text:p[@text:style-name='Heading_20_3']">
<!-- Traps heading 3 -->
    <xsl:variable name="underline" select="." />
    <xsl:value-of select="."/>
    <xsl:value-of select="translate($underline,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -','^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^')"/>
    <xsl:call-template name="twoNewlines" />
</xsl:template>

<xsl:template match="text:list">
   <xsl:call-template name="oneNewline" />
    <xsl:apply-templates />
    <xsl:call-template name="oneNewline" />
</xsl:template>

<xsl:template match="text:p">
<!-- Traps body paragraph -->
    <xsl:if test=". != '' or node()">
        <xsl:choose>
            <xsl:when test="../name() = 'text:list-item'">
            <!-- 
                If the current paragraph is part of a list, then compute the number of spaces to indent
                the list. The number of spaces is a function of the associaed style's fo:margin-left value.
                There are three spaces for each multiple of 0.5 inches of indent.
            -->
                 <xsl:variable name="styleName" select="@text:style-name" />
                <xsl:variable name="marginLeft" select="/descendant::style:style[@style:name = $styleName]/style:paragraph-properties/@fo:margin-left" />
                <xsl:variable name="numberSpaces" select= "((number(substring-before($marginLeft,'in')) div 0.5) - 1) * 3" />
                <xsl:value-of select="concat(substring('                  ',1,$numberSpaces), '#. ')"/>
                <xsl:apply-templates />    
               <xsl:call-template name="oneNewline" />
            </xsl:when>
            <xsl:otherwise>
            <!--
                Here we are at a paragraph that is not part of a list.
            -->
              <xsl:apply-templates />
              <xsl:call-template name="twoNewlines" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
</xsl:template>

<xsl:template match="text:span">
    <!--xsl:value-of select="concat('Value for string is',.)" />
    <xsl:value-of select="concat('Length of  string is ',string-length(.))" /-->
    <xsl:if test=". != ''">
    <xsl:variable name="spanstyle" select="@text:style-name" />
    <xsl:choose>
        <xsl:when test="/descendant::style:style[@style:name = $spanstyle]/style:text-properties[@fo:font-weight='bold']">
            <xsl:value-of select="concat('**',.,'**')" />
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="."/>
        </xsl:otherwise>
    </xsl:choose>    
    </xsl:if>
</xsl:template>

<xsl:template match="text:a[@xlink:type='simple']">
<!-- Creates an rSt hyperlink `Label <url>`_ 
     &#96; is a backtick
     &lt; is bracket-open
     &gt; is bracket-close
-->
     <xsl:value-of select="concat('&#96;',text:span,' &lt;',@xlink:href,'&gt;&#96;_')"/>
</xsl:template>


<!-- Nodes to ignore -->
<xsl:template match="text:sequence-decls|text:bookmark|draw:frame|draw:image|text:line-break|text:tab" />

<!-- Suppresses newline after each node. -->
<xsl:template match="text()" />

<xsl:template name="oneNewline">
    <xsl:text>&#xA;</xsl:text>
</xsl:template>

<xsl:template name="twoNewlines">
    <xsl:text>&#xA;&#xA;</xsl:text>
</xsl:template>

</xsl:stylesheet>

<!--  saxon -s:source.xml  -xsl:stylesheet.xsl -o:output.rst -->
<!--  saxon  -s:/tmp/barf/content.xml  -xsl:transform.xsl -->