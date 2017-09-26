#ifndef STYLEDTEXT_H
#define STYLEDTEXT_H

#include <QSize>
#include <QPointF>
#include <QList>
#include <QUrl>
#include <QImage>
#include <QTextLayout>

class StyledTextImgTag;
class StyledTextPrivate;
class QString;
class QQmlContext;

class StyledTextImgTag
{
public:
    StyledTextImgTag()
        : position(0), align(StyledTextImgTag::Bottom)
    { }

    ~StyledTextImgTag() { }

    enum Align {
        Bottom,
        Middle,
        Top
    };

    QUrl url;
    QPointF pos;
    QSize size;
    int position;
    Align align;
    QImage pix;
};

class StyledText
{
public:
    static void parse(const QString &string, QTextLayout &layout,
                      QList<StyledTextImgTag *> &imgTags,
                      const QUrl &baseUrl,
                      QQmlContext *context,
                      bool preloadImages,
                      bool *fontSizeModified, QTextCharFormat defaultFormat);

private:
    StyledText(const QString &string, QTextLayout &layout,
               QList<StyledTextImgTag *> &imgTags,
               const QUrl &baseUrl,
               QQmlContext *context,
               bool preloadImages,
               bool *fontSizeModified, QTextCharFormat defaultFormat);
    ~StyledText();

    StyledTextPrivate *d;
};

#endif // STYLEDTEXT_H
