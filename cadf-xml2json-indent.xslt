<?xml version="1.0"?>
<!-- Copyright (c) ola.nordstrom@citrix.com -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="ISO-8859-1" indent="no"/>

<!-- for this implementation pretty print the JSON output
     production implementations could remove all newline
     and tab* variables and rely on external formating tools -->
<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>
<xsl:variable name="tab">
<xsl:text>    </xsl:text>
</xsl:variable>
<xsl:variable name="tabtab">
<xsl:text>        </xsl:text>
</xsl:variable>
<xsl:variable name="tabtabtab">
<xsl:text>            </xsl:text>
</xsl:variable>

<xsl:template match="/Event">
    <xsl:text>{</xsl:text> 
        <xsl:value-of select="$tab"/><xsl:text>"Event": {</xsl:text><xsl:value-of select="$newline"/>

            <xsl:apply-templates select="typeURI | id | eventType | eventTime | initiator | action | target | outcome"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$newline"/>

            <!-- reporter chain is mandatory -->
            <xsl:apply-templates select="reporterchain"/>

            <!-- if there are more optional attributes append a comma and the
                 attribute -->
            <xsl:if test="./reason">
                <xsl:text>,</xsl:text><xsl:value-of select="$newline"/>
                <xsl:apply-templates select="reason"/>
            </xsl:if>

            <xsl:if test="./measurements">
                <xsl:text>,</xsl:text><xsl:value-of select="$newline"/>
                <xsl:apply-templates select="measurements"/>
            </xsl:if>

            <xsl:if test="./attachments">
                <xsl:text>,</xsl:text><xsl:value-of select="$newline"/>
                <xsl:apply-templates select="attachments"/>
            </xsl:if>

            <xsl:value-of select="$newline"/>

        <xsl:value-of select="$tab"/><xsl:text>}</xsl:text><xsl:value-of select="$newline"/>
    <xsl:text>}</xsl:text><xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template match="/Geolocation">
    <xsl:text>{</xsl:text> 
        <xsl:value-of select="$tab"/><xsl:text>"Geolocation": {</xsl:text><xsl:value-of select="$newline"/>
            <xsl:apply-templates select="id | latitude | longitude | elevation | accuracy | city | state | regionICANN"/>

            <xsl:if test="./annotation">
                <xsl:if test="./id | ./latitude | ./longitude | ./elevation | ./accuracy | ./city | ./state | ./regionICANN">
                    <xsl:text>,</xsl:text><xsl:value-of select="$newline"/>
                </xsl:if>
                <xsl:value-of select="$tabtab"/><xsl:text>"annotation": {</xsl:text>
                <xsl:value-of select="$newline"/>
                <xsl:for-each select="./annotation">
                    <xsl:value-of select="$tabtabtab"/><xsl:text>"</xsl:text><xsl:value-of select="@key"/><xsl:text>": </xsl:text>
                    <xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
                    <xsl:if test="position() != last()">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="$newline"/>
                </xsl:for-each>
                <xsl:value-of select="$tabtab"/><xsl:text>}</xsl:text><xsl:value-of select="$newline"/>
            </xsl:if>

            <xsl:if test="not(./annotation)">
                <xsl:value-of select="$newline"/>
            </xsl:if>

        <xsl:value-of select="$tab"/><xsl:text>}</xsl:text><xsl:value-of select="$newline"/>
    <xsl:text>}</xsl:text><xsl:value-of select="$newline"/>
</xsl:template>

<xsl:template match="id | latitude | longitude | elevation | accuracy | city | state | regionICANN |
                     typeURI | id | eventType | eventTime | initiator | action | target | outcome |
                     reason">
    <xsl:value-of select="$tabtab"/><xsl:text>"</xsl:text><xsl:value-of select="name()"/><xsl:text>": "</xsl:text>
    <xsl:value-of select="."/><xsl:text>"</xsl:text>

    <xsl:if test="position() != last()">
        <xsl:text>,</xsl:text><xsl:value-of select="$newline"/>
    </xsl:if>
</xsl:template>

<xsl:template match="measurements | attachments">
    <xsl:value-of select="$tabtab"/><xsl:text>"</xsl:text><xsl:value-of select="name()"/><xsl:text>": {</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:for-each select="child::*">
        <xsl:value-of select="$tabtabtab"/><xsl:text>"</xsl:text><xsl:value-of select="name()"/><xsl:text>": "</xsl:text>
        <xsl:value-of select="."/><xsl:text>"</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text><xsl:value-of select="$newline"/>
        </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="$newline"/>
    <xsl:value-of select="$tabtab"/><xsl:text>}</xsl:text>
</xsl:template>

<!-- TODO: handle the reporter chain list better and include the details -->
<xsl:template match="reporterchain">
    <xsl:value-of select="$tabtab"/><xsl:text>"</xsl:text><xsl:value-of select="name()"/><xsl:text>": [</xsl:text>
    <xsl:value-of select="$newline"/>
    <xsl:for-each select="child::*">
        <xsl:value-of select="$tabtabtab"/><xsl:text>"</xsl:text><xsl:value-of select="."/><xsl:text>"</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text><xsl:value-of select="$newline"/>
        </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="$newline"/>
    <xsl:value-of select="$tabtab"/><xsl:text>]</xsl:text>
</xsl:template>

</xsl:stylesheet>
