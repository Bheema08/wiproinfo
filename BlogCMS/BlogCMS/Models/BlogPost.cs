// Models/BlogPost.cs
using System.ComponentModel.DataAnnotations;

namespace BlogCMS.Models
{
    public class BlogPost
    {
        public int Id { get; set; }

        [Required]
        [MaxLength(255)]
        public string Title { get; set; }

        [Required]
        public string Content { get; set; }

        [MaxLength(500)]
        public string Excerpt { get; set; }

        [Required]
        [MaxLength(255)]
        public string Slug { get; set; }

        [MaxLength(500)]
        public string FeaturedImageUrl { get; set; }

        public int AuthorId { get; set; }
        public User Author { get; set; }

        [Required]
        [MaxLength(20)]
        public string Status { get; set; } = "Draft";

        public DateTime? PublishedAt { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

        [MaxLength(255)]
        public string MetaTitle { get; set; }

        [MaxLength(500)]
        public string MetaDescription { get; set; }

        [MaxLength(500)]
        public string Tags { get; set; }

        public List<Category> Categories { get; set; } = new List<Category>();



    }
}