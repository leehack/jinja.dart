/// Base class for all template errors.
abstract class TemplateError implements Exception {
  /// Creates a new [TemplateError].
  TemplateError([this.message]);

  /// The error message.
  final String? message;

  @override
  String toString() {
    if (message case var message?) {
      return 'TemplateError: $message';
    }

    return 'TemplateError';
  }
}

/// Thrown if a template does not exist.
class TemplateNotFound extends TemplateError {
  /// Creates a new [TemplateNotFound].
  TemplateNotFound({this.name, String? message}) : super(message);

  /// The name of the template that was not found.
  final String? name;

  @override
  String toString() {
    if (message case var message?) {
      return 'TemplateNotFound: $message';
    }

    if (name case var name?) {
      return 'TemplateNotFound: $name';
    }

    return 'TemplateNotFound';
  }
}

/// Like [TemplateNotFound], but thrown if multiple templates are selected.
class TemplatesNotFound extends TemplateNotFound {
  /// Creates a new [TemplatesNotFound].
  TemplatesNotFound({this.names, super.message}) : super(name: names?.last);

  /// The names of the templates that were not found.
  final List<String>? names;

  @override
  String toString() {
    if (message case var message?) {
      return 'TemplatesNotFound: $message';
    }

    if (names case var names?) {
      return 'TemplatesNotFound: '
          'none of the templates given were found: '
          '${names.join(', ')}';
    }

    return 'TemplatesNotFound';
  }
}

/// Thrown to tell the user that there is a problem with the template.
class TemplateSyntaxError extends TemplateError {
  /// Creates a new [TemplateSyntaxError].
  TemplateSyntaxError(super.message, {this.name, this.path, this.line});

  /// The name of the template that caused the error.
  final String? name;

  /// The path to the template that caused the error.
  final String? path;

  /// The line in the template that caused the error.
  final int? line;

  void _toStringBuffer(StringBuffer buffer) {
    if (path ?? name case var path?) {
      buffer
        ..write(", file '")
        ..write(path)
        ..write("'");
    }

    if (line case var line?) {
      buffer
        ..write(', line ')
        ..write(line);
    }

    if (message case var message?) {
      buffer
        ..write(': ')
        ..write(message);
    }
  }

  @override
  String toString() {
    var buffer = StringBuffer('TemplateSyntaxError');
    _toStringBuffer(buffer);
    return buffer.toString();
  }
}

/// Like a [TemplateSyntaxError], but covers cases where something in the
/// template caused an error at parsing time that wasn't necessarily caused
/// by a syntax error.
class TemplateAssertionError extends TemplateSyntaxError {
  /// Creates a new [TemplateAssertionError].
  TemplateAssertionError(super.message, {super.name, super.path, super.line});

  @override
  String toString() {
    var buffer = StringBuffer('TemplateAssertionError');
    _toStringBuffer(buffer);
    return buffer.toString();
  }
}

/// A generic runtime error in the template engine.
///
/// Under some situations Jinja may throw this exception.
class TemplateRuntimeError extends TemplateError {
  /// Creates a new [TemplateRuntimeError].
  TemplateRuntimeError([super.message]);

  @override
  String toString() {
    if (message case var message?) {
      return 'TemplateRuntimeError: $message';
    }

    return 'TemplateRuntimeError';
  }
}

/// Thrown if a variable is undefined.
class UndefinedError extends TemplateRuntimeError {
  /// Creates a new [UndefinedError].
  UndefinedError([super.message]);

  @override
  String toString() {
    if (message case var message?) {
      return 'UndefinedError: $message';
    }

    return 'UndefinedError';
  }
}
