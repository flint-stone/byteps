// Copyright 2019 Amazon Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =============================================================================

#ifndef BYTEPS_COMPRESSOR_COMMON_H
#define BYTEPS_COMPRESSOR_COMMON_H

#include <unordered_map>

namespace byteps {
namespace common {
namespace compressor {
typedef char byte_t;
/*!
 * \brief Tensor type
 */
typedef struct BPSTensor {
  byte_t* data;
  size_t size;
  int dtype;

  BPSTensor() : data(nullptr), size(0), dtype(0) {}
  BPSTensor(byte_t* data, size_t size=0, int dtype=0)
      : data(data), size(size), dtype(dtype) {}
} tensor_t;

using kwargs_t = std::unordered_map<std::string, std::string>;

}  // namespace compressor
}  // namespace common
}  // namespace byteps

#endif  // BYTEPS_COMPRESSOR_COMMON_H